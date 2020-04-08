//
//  ProgressIndicator.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    var configuration = { (view: NSProgressIndicator) in }
    
    func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        NSProgressIndicator()
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressIndicator>) {
        configuration(nsView)
    }
}
