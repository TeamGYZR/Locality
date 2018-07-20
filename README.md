# Project Locality


# App Description

-Locality is a location and photo centric travel app to help users conveniently find what attractions are around them. This app will let users sort though different categories of attractions around them, and then will populate a map with pin points of these attractions. The user can then click on these pin points and see a grid of images from this sight. 

## User Stories

The following **required** functionality is complete:

**Login**

* [x] User can login to their account or create a new account using Parse
* [x] Error messages if the user has not entered both an email/ password
* [x] Sign-up/ login buttons segue to explore page 
* [ ] Incorporate parse to track users and favorites
* [ ] OPTIONAL: Segue to sign-up screen from sign-up button to change profile picture and add email 
* [ ] OPTIONAL: Add standard profile picture if none is selected
* [ ] OPTIONAL: “Guest” flow optional
* [ ] OPTIONAL: polish design of log-in screen 

**Explore Map View**
* [x] Display Map view (Apple Map API)
* [x] Get user location permissions
* [ ] OPTIONAL: prompt to enable in Settings if they declined it
* [x] Center map view on current location
* [x] Display pins based on popular locations pulled from Four Square API
* [ ] Have pins show different colors based on the category the attraction is in (based on Yelp API)
* [ ] Search bar to change user location (Apple Map API, or location api)
* [x] Create a tap gesture segue from the pin to the collection view 
* [x] OPTIONAL: Tap on pin shows a preview on the information
* [x] Display a tab bar to switch between profile/ explore pages
* [ ] OPTIONAL: search refinement based on category
* [ ] OPTIONAL: Tapping on a pin will show a text bubble if other people the user knows have visited that place
* [ ] OPTIONAL: Polish design, style pin callout with .nib file
* [ ] OPTIONAL: Use 3D-Touch API to show a preview of the details of a venue

**Photo Collection View Page**
* [x] Display photos from the place in a collection view
* [x] Incorporate the Flickr and Fource API to access the photos of the location
* [x] Tapping on collection view cell will segue to details page
* [ ] Tapping on details button will segue to details page
* [ ] OPTIONAL: Single tap on photo makes it larger, double tap away makes the photo shrink back
* [ ] OPTIONAL: Use autolayout to fit view to every size

**Details View Page**
* [ ] Display main photo from the collection 
* [ ] Display attraction's name, address, distance, rating, phone number
* [ ] Add favorite button that the user can click to add the place to their profile
* [ ] OPTIONAL: Add sound to labels so user can hear pronunciation
* [ ] OPTIONAL: Come up with a gesture for localization/accessibility
* [ ] OPTIONAL: Reviews/Rating section where people can rate comment

**Profile Page View**
* [ ] Display in either a collection or table view a list of the user's favorited places
* [ ] Display user metadata
* [ ] Add profile photo optionally 
* [ ] OPTIONAL:  add headers to the view- maybe sorted by alphabet or by category
* [ ] Add a map of their own favorited places in profile page

**Additional Optional Stories**
* [ ] Users can view other user profiles
* [ ] Users can see other users' favorites and comments
* [ ] Users can friend other users


## Considerations:

What is your product pitch?

-Problem Statement: Finding things to do nearby is a hassle, involving google searches and reading through reviews, etc

-Our solution: We want to build a hyper-local and visual experience for discovering nearby attractions and things to keep busy.


Who are our key stakeholders? Who will be using this app?
 
-Hip people under 30/ travelers ot new places


What mobile features will we leverage in our app?

- Maps/Current location
- Camera (for optional profile picture)
- Text to speech (for optional accessibility) 



