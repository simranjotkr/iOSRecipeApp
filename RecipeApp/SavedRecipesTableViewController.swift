import UIKit
import CoreData

class SavedRecipesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<SavedRecipesEntity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }

    func setupFetchedResultsController() {
           let fetchRequest: NSFetchRequest<SavedRecipesEntity> = SavedRecipesEntity.fetchRequest()
           let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // Sort by title, adjust as needed
           fetchRequest.sortDescriptors = [sortDescriptor]
           
           fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
           fetchedResultsController.delegate = self
           
           do {
               try fetchedResultsController.performFetch()
               tableView.reloadData()
           } catch {
               print("Failed to fetch saved recipes: \(error)")
           }
       }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RandomRecipeTableViewCell
        let recipe = fetchedResultsController.object(at: indexPath)

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

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
   
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.reloadData()
    }
    
}
