//
//  NetworkingService.swift
//  RecipeApp
//
//  Created by Simranjot Kaur on 2024-04-11.
//

import Foundation

protocol NetworkingRandomRecipesDelegate {
    func networkingDidFinishWithListOfRandomRecipes(randomRecipesList : [RandomRecipeModel]);
    func networkingDidFinishWithError();
}

class NetworkingService {
    
    static var shared = NetworkingService()
    
    var randomRecipesDelegate: NetworkingRandomRecipesDelegate?
    
    func getRandomRecipes() {
        let apiKey = "3e1ce85ce4104391a021b5678f31fa50"
        let urlString = "https://api.spoonacular.com/recipes/random?number=30&apiKey=\(apiKey)"
        let urlObj = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: urlObj) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                self.randomRecipesDelegate?.networkingDidFinishWithError()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                self.randomRecipesDelegate?.networkingDidFinishWithError()
                return
            }
            
            guard let jsonData = data else {
                print("No data received")
                self.randomRecipesDelegate?.networkingDidFinishWithError()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let randomRecipeResponse = try decoder.decode(RandomRecipeResponse.self, from: jsonData)
                if let randomRecipes = randomRecipeResponse.recipes {
                    DispatchQueue.main.async {
                        self.randomRecipesDelegate?.networkingDidFinishWithListOfRandomRecipes(randomRecipesList: randomRecipes)
                    }
                } else {
                    print("No recipes found")
                    self.randomRecipesDelegate?.networkingDidFinishWithError()
                }
            } catch {
                print("Error decoding JSON: \(error)")
                self.randomRecipesDelegate?.networkingDidFinishWithError()
            }
        }
        task.resume()
    }
    
}
