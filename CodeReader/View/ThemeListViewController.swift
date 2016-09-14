//
//  ThemeListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/6/11.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class ThemeListViewController: UITableViewController {
    let viewModel = ThemeViewModel()
    var selectedTheme: Theme?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "Theme")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.themes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Theme", for: indexPath) as! ThemeCell
        let theme = viewModel.themes[(indexPath as NSIndexPath).section]
        if theme.isPurchased || DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            cell.lockImageView.isHidden = true
        } else {
            cell.lockImageView.isHidden = false
        }
        cell.contentView.backgroundColor = theme.colors[0]
        cell.nameLabel.text = theme.name
        cell.nameLabel.textColor = theme.colors[1]
        cell.colorView1.backgroundColor = theme.colors[2]
        cell.colorView2.backgroundColor = theme.colors[3]
        cell.colorView3.backgroundColor = theme.colors[4]
        cell.colorView4.backgroundColor = theme.colors[5]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = viewModel.themes[(indexPath as NSIndexPath).section]
        if theme.isPurchased || DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            performSegue(withIdentifier: "ChangeTheme", sender: indexPath)
        } else {
            let alertController = UIAlertController(title: "", message: "Please buy me a coffee to unlock all themes", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTheme" {
            if let indexPath = sender as? IndexPath{
                selectedTheme = viewModel.themes[(indexPath as NSIndexPath).section]
                UserDefaults.standard.set(selectedTheme?.name, forKey: "default_theme")
            }
        }
    }

}
