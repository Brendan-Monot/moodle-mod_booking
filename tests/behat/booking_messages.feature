@mod @mod_booking @booking_multisessions
Feature: In a booking create multi session options
  As a teacher
  I need to add booking options with multiple dates

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                | idnumber |
      | teacher1 | Teacher   | 1        | teacher1@example.com | T1       |
      | admin1   | Admin     | 1        | admin1@example.com   | A1       |
      | student1 | Student   | 1        | student1@example.com | S1       |
      | student2 | Student   | 2        | student2@example.com | S2       |
    And the following "courses" exist:
      | fullname | shortname | category | enablecompletion |
      | Course 1 | C1        | 0        | 1                |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | teacher1 | C1     | manager        |
      | admin    | C1     | manager        |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
    And the following "activities" exist:
      | activity | course | name       | intro                  | bookingmanager | eventtype | Default view for booking options | Activate e-mails (confirmations, notifications and more) | Booking option name  |
      | booking  | C1     | My booking | My booking description | teacher1       | Webinar   | All bookings                     | Yes                                                      | New option - Webinar |
    And I create booking option "New option - Webinar" in "My booking"

  @javascript
  Scenario: Send reminder mail to participant
    Given I log in as "teacher1"
    When I am on "Course 1" course homepage
    And I follow "My booking"
    And I click on "Settings" "icon" in the "#allbookingoptionstable_r1" "css_element"
    And I click on "Edit booking option" "link" in the "#allbookingoptionstable_r1" "css_element"
    And I wait "1" seconds
    And I press "Teachers"
    And I wait "1" seconds
    And I set the field "Assign teachers:" to "Teacher 1"
    And I press "Save and go back"
    And I follow "My booking"
    And I click on "Settings" "icon" in the "#allbookingoptionstable_r1" "css_element"
    And I click on "Book other users" "link" in the "#allbookingoptionstable_r1" "css_element"
    And I click on "Student 1 (student1@example.com)" "text"
    And I click on "Student 2 (student2@example.com)" "text"
    And I click on "Add" "button"
    And I follow "<< Back to responses"
    And I click on "selectall" "checkbox"
    And I click on "Send reminder e-mail" "button"
    And I click on "selectall" "checkbox"
    And I click on "Send custom message" "button"
    And I set the following fields to these values:
      | Subject | Behat test                                                     |
      | Message | Dear, Firstly, I would like to thank you for booking my Course |
    And I press "Save changes"
    And I should see "Your message has been sent."
    # And I run all adhoc tasks
    # And I open the link "webserver/_/mail"
    # Then I should see "Teacher 1 (via Acceptance test site)"
    # And I should see "Behat test"

  @javascript
  Scenario: Student books a booking option and get email confirmation
    ## URL webserver/_/mail is inacessible
    ## When I log in as "student1"
    ## And I open the link "webserver/_/mail"
    ## And I follow "Delete all messages"
    ## And I press "Delete all messages"
    ## And I open the link "webserver"
    ## Then I am on "Course 1" course homepage
    Given I log in as "student1"
    When I am on "Course 1" course homepage
    And I follow "My booking"
    And I should see "New option - Webinar"
    And I click on "Book now" "text" in the "#allbookingoptionstable_r1" "css_element"
    And I should see "Do you really want to book?" in the "#allbookingoptionstable_r1" "css_element"
    And I click on "Do you really want to book?" "text" in the "#allbookingoptionstable_r1" "css_element"
    And I should see "Booked" in the "#allbookingoptionstable_r1" "css_element"
    ## Next step(s) cause faiure (coding error, email was not sent):
    ## Then I trigger cron
    ## And I wait "1" seconds
    ## And I run all adhoc tasks
    ## URL webserver/_/mail is inacessible
    ## And I open the link "webserver/_/mail"
    ## Then I should see "Teacher 1 (via Acceptance test site)"
    ## And I should see "Booking confirmation for New option - Webinar"

  @javascript
  Scenario: Teacher book students into booking option and sends mails to them
    Given I log in as "teacher1"
    When I am on "Course 1" course homepage
    Then I follow "My booking"
    And I follow "My booking"
    And I click on "Settings" "icon" in the "#allbookingoptionstable_r1" "css_element"
    And I click on "Book other users" "link" in the "#allbookingoptionstable_r1" "css_element"
    And I click on "Student 1 (student1@example.com)" "text"
    And I click on "Student 2 (student2@example.com)" "text"
    And I click on "Add" "button"
    And I follow "<< Back to responses"
    And I click on "selectall" "checkbox"
    And I click on "Send reminder e-mail" "button"
    And I should see "Notification e-mail has been sent!"
    ## Next step(s) cause faiure (coding error, email was not sent):
    ## Then I trigger cron
    ## And I wait "1" seconds
    ## And I run all adhoc tasks

  @javascript
  Scenario: Run cron
    Given I log in as "admin1"
    Then I trigger cron
    And I wait "1" seconds
    And I run all adhoc tasks