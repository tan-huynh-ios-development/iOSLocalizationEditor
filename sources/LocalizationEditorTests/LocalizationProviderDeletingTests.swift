//
//  LocalizationProviderDeletingTests.swift
//  LocalizationEditorTests
//
//  Created by Igor Kulman on 06/03/2019.
//  Copyright © 2019 Igor Kulman. All rights reserved.
//

import Foundation
import XCTest
@testable import LocalizationEditor

class LocalizationProviderDeletingTests: XCTestCase {
    func testDeletingValuesInSingleLanguage() {
        let directoryUrl = createTestingDirectory(with: [TestFile(originalFileName: "LocalizableStrings-en.strings", destinationFileName: "LocalizableStrings.strings", destinationFolder: "Base.lproj")])
        let provider = LocalizationProvider()
        let groups = provider.getLocalizations(url: directoryUrl)

        let baseLocalization = groups[0].localizations[0]
        let count = groups[0].localizations[0].translations.count
        let key = baseLocalization.translations[2].key
        provider.deleteKeyFromLocalization(localization: baseLocalization, key: key)
        let updated = provider.getLocalizations(url: directoryUrl)

        XCTAssertEqual(updated.count, groups.count)
        XCTAssertEqual(groups[0].localizations.count, groups[0].localizations.count)
        XCTAssertEqual(groups[0].localizations[0].translations.count, count - 1)
        XCTAssert(!groups[0].localizations[0].translations.contains(where: { $0.key ==  key}))
        XCTAssertEqual(updated[0].localizations.count, groups[0].localizations.count)
        XCTAssertEqual(updated[0].localizations[0].translations.count, count - 1)
        XCTAssert(!updated[0].localizations[0].translations.contains(where: { $0.key ==  key}))
    }

    func testDeletingValuesInMultipleLanguage() {
        let directoryUrl = createTestingDirectory(with: [TestFile(originalFileName: "LocalizableStrings-en.strings", destinationFileName: "LocalizableStrings.strings", destinationFolder: "Base.lproj"), TestFile(originalFileName: "LocalizableStrings-sk.strings", destinationFileName: "LocalizableStrings.strings", destinationFolder: "sk.lproj")])
        let provider = LocalizationProvider()
        let groups = provider.getLocalizations(url: directoryUrl)

        let baseLocalization = groups[0].localizations[0]
        let key = baseLocalization.translations[2].key
        let count = groups[0].localizations[0].translations.count
        let countOther = groups[0].localizations[1].translations.count
        provider.deleteKeyFromLocalization(localization: baseLocalization, key: baseLocalization.translations[2].key)
        let updated = provider.getLocalizations(url: directoryUrl)

        XCTAssertEqual(updated.count, groups.count)
        XCTAssertEqual(groups[0].localizations.count, groups[0].localizations.count)
        XCTAssertEqual(groups[0].localizations[0].translations.count, count - 1)
        XCTAssertEqual(groups[0].localizations[1].translations.count, countOther)
        XCTAssert(!groups[0].localizations[0].translations.contains(where: { $0.key ==  key}))
        XCTAssertEqual(updated[0].localizations.count, groups[0].localizations.count)
        XCTAssertEqual(updated[0].localizations[0].translations.count, count - 1)
        XCTAssertEqual(updated[0].localizations[1].translations.count, countOther)
        XCTAssert(!updated[0].localizations[0].translations.contains(where: { $0.key ==  key}))
    }
}
