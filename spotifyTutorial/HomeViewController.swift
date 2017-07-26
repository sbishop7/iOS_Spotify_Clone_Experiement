//
//  ViewController.swift
//  spotifyTutorial
//
//  Created by Daniel Thompson on 7/24/17.
//  Copyright © 2017 Daniel Thompson. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    let clientID = "ae9d84e70f4b4ba487165a760dbb8b31"
    
    var player = SPTAudioStreamingController.sharedInstance()!
    var paused = false
    var track = "spotify:track:58s6EuEYJdlb0kO7awm3Vp"
    
    @IBOutlet weak var slider: UISlider!
    
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
//            paused = true
            print(player.playbackState.position)

        } else {
            player.setIsPlaying(true, callback: nil)
//            paused = false
        }
    }

    @IBAction func changeAudioTime(_ sender: UISlider) {
        let currentTime = TimeInterval(slider.value)
        slider.value = Float(currentTime)
        player.seek(to: currentTime, callback: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        Playlist.getListOfFeaturedPlaylists(params: [:]){
        data, response, error in
        }
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HomeViewController.updateSlider), userInfo: nil, repeats: true)
        print ("Hello there")
    }
    
    func updateSlider() {
//        if (player.playbackState?.isPlaying)! {
            if (player.metadata?.currentTrack != nil) {
//            print("there is metadata")
//            print(player.metadata.currentTrack!)
                slider.maximumValue = Float((player.metadata.currentTrack?.duration)!)
                slider.value = Float(player.playbackState.position)
            }
//        slider.value = Float(player.playbackState.position)sdfasdfas
//        }
    }
    
    
}

