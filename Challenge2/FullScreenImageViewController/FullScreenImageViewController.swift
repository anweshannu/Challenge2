//
//  FullScreenImageViewController.swift
//  Challenge2
//
//  Created by Anwesh M on 08/02/22.
//

import UIKit

class FullScreenImageViewController: UIViewController{
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullScreenImageView: UIImageView!
    var index: Int!
    var characters: CharactersModel!
    
    override func viewDidLoad() {
        loadImage(index: index)
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        index -= 1
        loadImage(index: index)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        index += 1
        loadImage(index: index)
    }
    
    private func loadImage(index: Int){
        guard index < characters.count else{
            return
        }
        downloadImage(from: URL(string: characters[index].img ?? "no image")!)
        nameLabel.text = characters[index].name
        
        previousButton.isHidden = index == 0
        nextButton.isHidden = index == characters.count - 1
    }
    
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { [weak self] in
                self?.fullScreenImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
