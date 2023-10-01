//
//  CharacterTableViewCell.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    @IBOutlet weak var characterDescription: UITextView!
    
    private final let maxDescriptionLength = 140
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with character: any CharacterProtocol) {
        characterImage.setImage(for: character.photo)
        characterName.text = character.name
        characterDescription.text = truncateDescription(character.description)
    }
    
    private func truncateDescription(_ description: String) -> String {
        if description.count > maxDescriptionLength {
            return String(description.prefix(maxDescriptionLength - 3)) + "..."
        }
        return description
    }
}
