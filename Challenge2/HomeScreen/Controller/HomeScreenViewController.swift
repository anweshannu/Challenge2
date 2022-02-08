//
//  HomScreenViewController.swift
//  Challenge2
//
//  Created by Anwesh M on 08/02/22.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    ///References to UI components
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var charactersTableView: UITableView!
    
    ///Variables
    private var homeScreenControllerViewModel: HomeScreenControllerViewModel!
    private var characters: CharactersModel?
    private var charactersForTableView: CharactersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewDidLayoutSubviews() {
        setLocation()
    }
    
    
    private func initialSetup(){
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        searchBar.delegate = self
        setTitle()
        setLocation()
        fetchDataFromServer()
    }
    
    private func fetchDataFromServer(){
        homeScreenControllerViewModel = HomeScreenControllerViewModel()
        homeScreenControllerViewModel.delegate = self
        homeScreenControllerViewModel.fetchCharactersData()
        homeScreenControllerViewModel.fetchDataFromServer()
    }
    
    private func setTitle(){
        self.title = "NEWS"
        self.navigationController?.navigationBar.barTintColor = UIColor.systemYellow
    }
    
    private func setLocation(){
        let locationButton = UIButton(type: .system)
        locationButton.setImage(UIImage(systemName: "location"), for: .normal)
        locationButton.setTitle("Hyderabad", for: .normal)
        locationButton.sizeToFit()
        //        locationButton.addTarget(self, action: #selector(yourFunctionAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationButton)
    }
    
}


extension HomeScreenViewController: DataFromAPI{
    
    func onDatafetched(characters: CharactersModel) {
        self.characters = characters
        self.charactersForTableView = characters
        
        DispatchQueue.main.async { [weak self] in
            self?.charactersTableView.reloadData()
        }
    }
}


extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charactersForTableView?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCardTVCell", for: indexPath) as! CharacterCardTVCell
        let data = charactersForTableView?[indexPath.row]
        cell.downloadImage(from: URL(string: data?.img ?? "temp")!)
        cell.nameLabel.text = data?.name
        cell.statusLabel.text = data?.status?.rawValue
        cell.characterId = data?.charID
        cell.descriptionLabel.text = data?.occupation?.joined(separator: " ")
        cell.backgroundColor =  .random()
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
        vc.index = indexPath.row
        vc.characters = self.charactersForTableView
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}


extension HomeScreenViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchText.count > 0{
            charactersForTableView = characters?.filter({ characterModel in
                characterModel.name!.lowercased().contains(searchText.lowercased())
            })
        }
        else{
            charactersForTableView = characters
        }
        DispatchQueue.main.async { [weak self] in
            self?.charactersTableView.reloadData()
        }
        
        
    }
}
