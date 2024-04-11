import UIKit
import WebKit

class RandomRecipeTableViewController: UITableViewController, NetworkingRandomRecipesDelegate {

    var localRandomRecipes = [RandomRecipeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.shared.randomRecipesDelegate = self
        NetworkingService.shared.getRandomRecipes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localRandomRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RandomRecipeTableViewCell
        let recipe = localRandomRecipes[indexPath.row]
        cell.recipe = recipe
        // Configure the cell with recipe details
        cell.title.text = recipe.title
        cell.servings.text = "Serves: \(recipe.servings ?? 1)"
        cell.onViewRecipeTapped = {
            if let urlString = recipe.sourceUrl, let url = URL(string: urlString), let viewController = UIApplication.shared.keyWindow?.rootViewController {
                let webView = UIWebView(frame: viewController.view.bounds)
                webView.loadRequest(URLRequest(url: url))
                viewController.view.addSubview(webView)
            }
        }
        
        downloadImage(iconValue: recipe.image ?? "") { (image) in
            DispatchQueue.main.async {
                cell.recipeImage.image = image
            }
        }
        
        return cell
    }


    func downloadImage(iconValue: String, completion: @escaping (UIImage?) -> Void) {
        let myQ = DispatchQueue(label: "myQ")
        myQ.async {
            let iconURL = iconValue
            if let urlObject = URL(string: iconURL) {
                do {
                    let imageData = try Data(contentsOf: urlObject)
                    let image = UIImage(data: imageData)
                    completion(image)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }

    
    // MARK: - NetworkingRandomRecipesDelegate

    func networkingDidFinishWithListOfRandomRecipes(randomRecipesList: [RandomRecipeModel]) {
        localRandomRecipes = randomRecipesList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func networkingDidFinishWithError() {
        print("Networking error occurred")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}
