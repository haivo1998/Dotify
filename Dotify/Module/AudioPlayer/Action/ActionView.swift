//
//  ActionView.swift
//  Dotify
//
//  Created by Lucas Pham on 7/19/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

class ActionView: BaseViewXib {

    @IBOutlet weak var addToListView: UIView!
    @IBOutlet weak var shareView: UIView!
    //MARK: Properties
    var parentVC: AudioPlayerViewController?
    
    override func setUpViews() {
        let addToListTapGes = UITapGestureRecognizer(target: self, action: #selector(didTapAddToList))
        addToListView.addGestureRecognizer(addToListTapGes)
        
        let shareTapGes = UITapGestureRecognizer(target: self, action: #selector(didTapShare(_:)))
        shareView.addGestureRecognizer(shareTapGes)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        if parentVC == nil { return }
        parentVC?.dismisBlackView()
    }
    @objc func didTapShare(_ sender: UIView){
        let urlImage = AudioPlaying.ins.song?.imageUrl ?? ""
        URLSession.shared.dataTask(with: URL(string: urlImage)!) { (data, response, error) in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data) ?? #imageLiteral(resourceName: "ic_playlists_tapped")
            let activityVC = UIActivityViewController(activityItems: [image, AudioPlaying.ins.song?.name ?? "", "\nListen it at: \(AudioPlaying.ins.song?.link ?? "")"], applicationActivities: nil)
            self.parentVC?.present(activityVC, animated: true, completion: nil)
        }.resume()
    }
    
    @objc func didTapAddToList() {
        if parentVC == nil { return }
        parentVC?.dismisBlackView()
        parentVC?.navigationController?.pushViewController(ListPlayListRouter.createModule(), animated: true)
    }
}
