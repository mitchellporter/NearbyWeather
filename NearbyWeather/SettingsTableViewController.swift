//
//  SettingsTableViewController.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 03.12.16.
//  Copyright © 2016 Erik Maximilian Martens. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Override Functions
    
    /* General */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("SettingsTVC_NavigationBarTitle", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsTableViewController.didTapDoneButton(_:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsTableViewController.reloadTableViewData(_:)), name: Notification.Name(rawValue: NotificationKeys.weatherServiceUpdated.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsTableViewController.reloadTableViewData(_:)), name: Notification.Name(rawValue: NotificationKeys.apiKeyUpdated.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsTableViewController.reloadTableViewData(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    /* TableView */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SettingsInputTVC") as! SettingsInputTableViewController
            destinationViewController.mode = .enterFavoritedLocation
            navigationController?.pushViewController(destinationViewController, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SettingsInputTVC") as! SettingsInputTableViewController
            destinationViewController.mode = .enterAPIKey
            navigationController?.pushViewController(destinationViewController, animated: true)
        case 2:
            WeatherService.current.amountResults = AmountResults(rawValue: indexPath.row).integerValue
            tableView.reloadData()
            break
        case 3:
            WeatherService.current.temperatureUnit = TemperatureUnit(rawValue: indexPath.row)
            tableView.reloadData()
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("SettingsTVC_SectionTitle1", comment: "")
        case 1:
            return NSLocalizedString("SettingsTVC_SectionTitle2", comment: "")
        case 2:
            return NSLocalizedString("SettingsTVC_SectionTitle3", comment: "")
        case 3:
            return NSLocalizedString("SettingsTVC_SectionTitle4", comment: "")
        default:
            return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return AmountResults.count
        case 3:
            return TemperatureUnit.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.accessoryType = .none
        
        switch indexPath.section {
        case 0:
            cell.contentLabel.text! = WeatherService.current.favoritedLocation
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            cell.contentLabel.text! = UserDefaults.standard.value(forKey: "nearby_weather.openWeatherMapApiKey") as! String
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let amountResults = AmountResults(rawValue: indexPath.row).integerValue
            cell.contentLabel.text! = "\(amountResults) \(NSLocalizedString("SettingsTVC_Results", comment: ""))"
            if amountResults == WeatherService.current.amountResults {
                cell.accessoryType = .checkmark
            }
            return cell
        case 3:
            let temperatureUnit = TemperatureUnit(rawValue: indexPath.row)
            cell.contentLabel.text! = temperatureUnit.stringValue
            if temperatureUnit.stringValue == WeatherService.current.temperatureUnit.stringValue {
                cell.accessoryType = .checkmark
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /* Deinitializer */
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Helper Functions
    
    @objc func reloadTableViewData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    // MARK: - Button Interaction
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
