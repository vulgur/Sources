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

        tableView.registerNib(UINib.init(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "Theme")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.themes.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Theme", forIndexPath: indexPath) as! ThemeCell
        let theme = viewModel.themes[indexPath.section]
        cell.contentView.backgroundColor = theme.colors[0]
        cell.nameLabel.text = theme.name
        cell.nameLabel.textColor = theme.colors[1]
        cell.colorView1.backgroundColor = theme.colors[2]
        cell.colorView2.backgroundColor = theme.colors[3]
        cell.colorView3.backgroundColor = theme.colors[4]
        cell.colorView4.backgroundColor = theme.colors[5]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ChangeTheme", sender: indexPath)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChangeTheme" {
            if let indexPath = sender as? NSIndexPath{
                    selectedTheme = viewModel.themes[indexPath.section]
            }
        }
    }

}
