//
//  DetailViewController.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UITextView!
    @IBOutlet weak var transformationsButton: UIButton!
    
    private let dragonBallApi = DragonBallAPIDataProvider()
    
    private var character: CharacterProtocol
    private var transformations: [TransformationModel] = []
    
    init(character: CharacterProtocol) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [self] in
            title = self.character.name
            characterImage.setImage(for: character.photo)
            characterName.text = character.name
            characterDescription.text = character.description
            self.transformationsButton.isHidden = true
            dragonBallApi.getTransformations(for: self.character) {  result in
                switch result {
                case let .success(characterTransformations):
                    DispatchQueue.main.async {
                        self.transformations.append(contentsOf: characterTransformations)
                        if self.transformations.count > 0 {
                            self.transformationsButton.isHidden = false
                        }
                    }
                case let .failure(error):
                    print("DataLoadingError(Transformations). Error description: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func tapCharacterTransformations(_ sender: Any) {
        self.navigationController?.show(CharacterViewController(characters: transformations), sender: nil)
    }
    
}
