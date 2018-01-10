Stanford iTune-U iOS 10 Development using Swift
===============================================

Repository holding assignments and other code for iOS 10 using Swift from Stanford on iTunes-U

**note:** used xcode 8 at the beginning of the project and then moved to xcode 9.  Tried to maintain code base at swift 3 versus swift 4, but things may have got mudied along the way

**regarding the assignments with workspaces (I.xcworkspace):** you will likely have to:
1. create a new workspace, or edit the existing workspace and remove all the projects
2. (re)import the projects into the workspace
3. in the consumer project, go to project settings, general tab, and remove the consumed project(s) from **Embeded Binaries** and **Linked Frameworks and Libraries** and re-add the consumed projects
