@javascript
Feature: Tracking of status of laboratory assets by an operator
In order to keep track of the actual status of the laboratory assets
An operator
Should be able to know past, present and future of any asset while working with it

Scenario: Perform a step within the system

Given I am an operator called "Bob"
When I use the browser to enter in the application
Then I should see the Instruments page

Scenario: Create a new activity with some assets
Given I have to process these tubes that are on my table:
|  Barcode | Facts                   |
|  1       | is:NotStarted, a:Tube   |
|  2       | is:NotStarted, a:Tube   |

Given we use these activity types:
| Name          |
| Tubes to rack |
| Reracking     |

Given we use these step types:
| Name           | Activity types |
| Upload layout  | Tubes to rack |

Given I have the following kits in house
| Barcode | Kit type                           | Activity type |
| 1       | QIAamp Investigator BioRobot       | Tubes to rack |
| 2       | QIAamp Investigator BioRobot       | Tubes to rack |
| 3       | QIAamp Investigator BioRobot       |               |
| 4       | QIAamp 96 DNA QIAcube HT           |               |

Given the laboratory has the following instruments:
| Barcode | Name          | Activity types           |
| 1       | My instrument | Tubes to rack, Reracking |

When I create an activity with instrument "My Instrument" and kit "1"
Then I should have created an empty activity for "Tubes to rack"

And when I scan these barcodes into the selection basket:
|Barcode |
| 1      |
| 2      |

Then I should see these barcodes in the selection basket:
| Barcode |
| 1       |
| 2       |
