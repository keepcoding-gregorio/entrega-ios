//
//  CharacterViewController.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import UIKit

class CharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let characters: [CharacterProtocol]
    
    init(characters: [CharacterProtocol]) {
        self.characters = characters
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dragon Ball Characters"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharactersCellReusable")
        tableView.estimatedRowHeight = 150
    }
    
    // MARK: - Table View Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersCellReusable", for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        let character = characters[indexPath.row]
        cell.config(with: character)
        return cell
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.show(DetailViewController(character: characters[indexPath.row]), sender: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
