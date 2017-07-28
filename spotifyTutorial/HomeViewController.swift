//
//  ViewController.swift
//  spotifyTutorial
//
//  Created by Daniel Thompson on 7/24/17.
//  Copyright © 2017 Daniel Thompson. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation



class HomeViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate, SPTCoreAudioControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let clientID = "ae9d84e70f4b4ba487165a760dbb8b31"
    
    var player = SPTAudioStreamingController.sharedInstance()!
    var paused = false
    var track = "spotify:album:297AQHapCeBHluODsEnKXg"
    var currentLibrary = [NSDictionary]()
    var currentAlbum = ""
    var currentArtist = ""
    
    @IBOutlet weak var headerTrackLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var getNewMusicLabel: UIButton!
    
    @IBOutlet weak var headerAlbumLabel: UILabel!
    @IBOutlet weak var headerArtistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentAlbumArt: UIImageView!
    
    @IBAction func getNewMusicButtonPressed(_ sender: UIButton) {
        getNewMusic()
        getNewMusicLabel.isHidden = true
        tableView.isHidden = false
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        print("play button pressed")
        player.playSpotifyURI(track, startingWith: 0, startingWithPosition: 0, callback: {
            (error) in
//            self.slider.maximumValue = Float((self.player.metadata.currentTrack?.duration)!)
            if let streamingError = error {
                print("error in playSpotifyURI \(String(describing: streamingError.localizedDescription))")
            }
        })
//        paused = false
//        if player.playbackState?.isPlaying == true {
//            slider.maximumValue = Float((player.metadata.currentTrack?.duration)!)
//            print("updating slider")
//        }
    }
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
//        slider.maximumValue = Float((player.metadata.currentTrack?.duration)!)
        if player.playbackState.isPlaying == true {
            player.setIsPlaying(false, callback: nil)
            pauseButton.setTitle("Play", for: .normal)

            
//            paused = true
//            print(player.playbackState.position)

        } else {
            player.setIsPlaying(true, callback: nil)
            pauseButton.setTitle("Pause", for: .normal)
//            paused = false
        }
    }

    @IBAction func changeAudioTime(_ sender: UISlider) {
        if player.playbackState.isPlaying == true {
            print("changing")
            player.setIsPlaying(false, callback: nil)
//            //            paused = true
////            print(player.playbackState.position)
//            let songLength = player.metadata.currentTrack?.duration
            let currentTime = TimeInterval(slider.value)
//            slider.value = Float(currentTime * songLength!)
            player.seek(to: currentTime, callback: nil)
            DispatchQueue.main.async {
                self.player.setIsPlaying(true, callback: nil)
                print("restarting")
            }
            
//
        }
//        let songLength = player.metadata.currentTrack?.duration
//        let currentTime = TimeInterval(slider.value * songLength)
//        slider.value = Float(currentTime)
//        player.seek(to: currentTime, callback: nil)
//        print(player.playbackState.position)
        
        
    }
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        artistLabel.isHidden = true
        albumLabel.isHidden = true
        trackLabel.isHidden = true
        headerTrackLabel.isHidden = true
        headerArtistLabel.isHidden = true
        headerAlbumLabel.isHidden = true
        
        Playlist.getListOfFeaturedPlaylists(params: [:]){
        data, response, error in
//            print ("error is ...\(String(describing: error))")
        }
        super.viewDidLoad()
        pauseButton.isHidden = true
        if self.currentLibrary.count == 0 {
            tableView.isHidden = true
        }
        // slider.isHidden = true#1	0x00000001079915de in HomeViewController.viewDidLoad() -> () at /Users/sbishop7/Code/spotify-master/spotifyTutorial/HomeViewController.swift:106

        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(HomeViewController.updateSlider), userInfo: nil, repeats: true)
        print ("Hello there")
        
//        do {
//            
//            if appDelegate.auth.session != nil {
//                print("AccessToken is... \(appDelegate.auth.session.accessToken)")
//            
//                let request = try SPTBrowse.createRequestForNewReleases(inCountry: nil, limit: 10, offset: 0, accessToken: appDelegate.auth.session.accessToken)
//                let session = URLSession.shared
//                let dataTask = session.dataTask(with: request) {
//                    data, response, error in
////                  print("data is... \(data!)")
//                    let jsonData = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                
//                    if jsonData["albums"] != nil {
//                        let albums = jsonData["albums"] as! NSDictionary
//                        let albumData = albums["items"] as! NSArray
//                        print("albumData count is ... \(albumData.count)")
//                
//                        for album in albumData {
//                            let albumInfo = album as! NSDictionary
////                          print(albumInfo)
//                            self.currentLibrary.append(albumInfo)
////                          print (self.currentLibrary)
//                        }
//                    }
//                
//                    DispatchQueue.main.async {
////                      print ("******* currentLibrary *******")
//////                    print("currentLibrary.count is.... \(self.currentLibrary.count)")
////                      print (self.currentLibrary[0])
//                        self.tableView.reloadData()
//                    }
//                
//                
//                }
//                dataTask.resume()
//            }
//            
//        } catch {
//            print("didn't work")
//        }

//        print ("******* currentLibrary *******")
//        print("currentLibrary.count is.... \(currentLibrary.count)")
//        print (currentLibrary)
////
    }
    
    func getNewMusic() {
        
        do {
            
            if appDelegate.auth.session != nil {
                print("AccessToken is... \(appDelegate.auth.session.accessToken)")
                
                let request = try SPTBrowse.createRequestForNewReleases(inCountry: nil, limit: 10, offset: 0, accessToken: appDelegate.auth.session.accessToken)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request) {
                    data, response, error in
                    //                  print("data is... \(data!)")
                    let jsonData = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    if jsonData["albums"] != nil {
                        let albums = jsonData["albums"] as! NSDictionary
                        let albumData = albums["items"] as! NSArray
                        print("albumData count is ... \(albumData.count)")
                        
                        for album in albumData {
                            let albumInfo = album as! NSDictionary
                            //                          print(albumInfo)
                            self.currentLibrary.append(albumInfo)
                            //                          print (self.currentLibrary)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        //                      print ("******* currentLibrary *******")
                        ////                    print("currentLibrary.count is.... \(self.currentLibrary.count)")
                        //                      print (self.currentLibrary[0])
                        self.tableView.reloadData()
                    }
                    
                    
                }
                dataTask.resume()
            }
            
        } catch {
            print("didn't work")
        }
    }

    
    func updateSlider() {
//        if player.playbackState.isPlaying == true {
            if (player.metadata?.currentTrack != nil) {
                if player.playbackState.isPlaying == true {
//            print("there is metadata")
//            print(player.metadata.currentTrack!)
                    slider.maximumValue = Float((player.metadata.currentTrack?.duration)!)
                    slider.value = Float(player.playbackState.position)
                    trackLabel.text = player.metadata.currentTrack?.name
                }
            }
//        slider.value = Float(player.playbackState.position)sdfasdfas
//        }
    }
    
    private func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack position: TimeInterval) {
        if let track = self.player.metadata.currentTrack{
            slider.value = Float(position/track.duration)
        }
        print("started playback")
    }
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didSeekToPosition position: TimeInterval) {
        if let track = self.player.metadata.currentTrack{
            slider.value = Float(position/track.duration)
            player.setIsPlaying(true, callback: nil)
        }
        print("didSeekToPosition")
    }
//    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
//        if let track = self.player.metadata.currentTrack{
//            slider.value = Float(position/track.duration)
//        }
//        print("didChangePosition")
//    }
    

    
    func getImage(_ url_str:String, _ imageView:UIImageView) {
        print("inside getImage function")
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            ( data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if(image != nil) {
                    
                }
            }
        })
        task.resume()
    }
    
    
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistCell
        if currentLibrary.count > 0 {
            cell.playlistNameLabel?.text = currentLibrary[indexPath.row]["name"] as? String
        //        cell.textLabel?.text = "Hello World"
            let images = currentLibrary[indexPath.row]["images"] as? NSArray
//            print(images!)
            let thumbnail = images?[2] as? NSDictionary
            let thumbnailURL = thumbnail?["url"]
            print(thumbnailURL!)
        
        
//        func getImage(_ url_str: String, _ imageView:UIImageView) {
//            print("inside new function")
            let url:URL = URL(string: thumbnailURL as! String)!
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: {
                ( data, response, error) in
                if data != nil {
                    print("found image data")
                    let image = UIImage(data: data!)
                    if(image != nil) {
                        DispatchQueue.main.async {
                            cell.albumArt?.image = image
                        }
                    }
                }
            })
            task.resume()
        }

        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let uri = currentLibrary[indexPath.row]["uri"] as? String
//        print("uri is... \(indexPath.row)")
//        
//    }
    

}


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uri = currentLibrary[indexPath.row]["uri"]
        currentAlbum = (currentLibrary[indexPath.row]["name"] as? String)!
        let artists = currentLibrary[indexPath.row]["artists"] as? NSArray
        let artist = artists?[0] as? NSDictionary
        currentArtist = (artist?["name"] as? String)!
        artistLabel.text = currentArtist
        artistLabel.isHidden = false
        albumLabel.text = currentAlbum
        albumLabel.isHidden = false
        trackLabel.isHidden = false
        headerAlbumLabel.isHidden = false
        headerArtistLabel.isHidden = false
        headerTrackLabel.isHidden = false
        
        track = uri as! String
//        print("track is... \(track)")
        player.playSpotifyURI(track, startingWith: 0, startingWithPosition: 0, callback: {
            (error) in
            if let streamingError = error {
                print("error in playSpotifyURI \(String(describing: streamingError.localizedDescription))")
            }
        })
        
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.isHidden = false
        
        let images = currentLibrary[indexPath.row]["images"] as? NSArray
        //            print(images!)
        let thumbnail = images?[0] as? NSDictionary
        let thumbnailURL = thumbnail?["url"]
        print(thumbnailURL!)
        
        let url:URL = URL(string: thumbnailURL as! String)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            ( data, response, error) in
            if data != nil {
                print("found image data")
                let image = UIImage(data: data!)
                if(image != nil) {
                    DispatchQueue.main.async {
                        self.currentAlbumArt.image = image
                    }
                }
            }
        })
        task.resume()
    }

}
