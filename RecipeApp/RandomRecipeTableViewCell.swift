//
//  RandomRecipeTableView.swift
//  RecipeApp
//
//  Created by Simranjot Kaur on 2024-04-11.
//

import UIKit

class RandomRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    
    
    @IBOutlet weak var starRecipe: UIButton!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sourceLink: UIButton!
    var recipe:RandomRecipeModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func starRecipeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            if let recipe = self.recipe {
                saveRecipeToCoreData(recipe)
            } else {
                // Handle the case where recipe is nil
            }
        } else {
            // Handle the case where the button is deselected
        }
    }
    
    private func saveRecipeToCoreData(_ recipe: RandomRecipeModel) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = CoreDataStack.shared.persistentContainer.viewContext

            // Create a new SavedRecipes managed object
            let savedRecipe = SavedRecipesEntity(context: context)
            savedRecipe.title = recipe.title
            savedRecipe.image = recipe.image
            savedRecipe.sourceUrl = recipe.sourceUrl
            savedRecipe.servings = Int32(recipe.servings ?? 0) // Assuming servings is an Int

            // Save the managed object to Core Data
            do {
                try context.save()
                print("Recipe saved to Core Data")
            } catch {
                print("Failed to save recipe to Core Data: \(error)")
            }
        }
    
    var onViewRecipeTapped: (() -> Void)?
    @IBAction func viewRecipeOnClick(_ sender: Any) {
        onViewRecipeTapped?()
    }
    
}
