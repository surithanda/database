# MySQL Database Error Codes Documentation

This document provides a comprehensive list of all error codes used in the stored procedures of the MySQL database. The error codes are organized by table/procedure group and include a brief description of each error.

## Error Code Format

All custom error codes follow the format:
- SQLSTATE '45000' (Custom error)
- Numeric error code in the range 50000-69999, grouped by table

## Error Codes by Table

### Profile Personal (50000-50999)
- `50001`: Invalid profile_id. It must be a positive integer.
- `50002`: Profile does not exist.
- `50003`: Invalid account_id. It must be a positive integer.
- `50004`: Account does not exist.
- `50005`: First name is required.
- `50006`: Last name is required.
- `50007`: Invalid gender value.
- `50008`: Date of birth is required.
- `50009`: Date of birth cannot be in the future.
- `50010`: Profile with this account_id already exists.

### Profile Address (51000-51999)
- `51001`: Invalid profile_id. It must be a positive integer.
- `51002`: Profile does not exist.
- `51003`: Address line 1 is required.
- `51004`: City is required.
- `51005`: State/Province is required.
- `51006`: Country is required.
- `51007`: Postal code is required.
- `51008`: Address type is required.
- `51009`: Invalid address type.
- `51010`: Address ID not found.
- `51011`: Invalid address ID. It must be a positive integer.

### Profile Contact (52000-52999)
- `52001`: Invalid profile_id. It must be a positive integer.
- `52002`: Profile does not exist.
- `52003`: Contact type is required.
- `52004`: Invalid contact type.
- `52005`: Contact value is required.
- `52006`: Contact ID not found.
- `52007`: Invalid contact ID. It must be a positive integer.
- `52008`: Contact with this value already exists for this profile.

### Profile Education (53000-53999)
- `53001`: Invalid profile_id. It must be a positive integer.
- `53002`: Profile does not exist.
- `53003`: Institution name is required.
- `53004`: Degree is required.
- `53005`: Field of study is required.
- `53006`: Start date is required.
- `53007`: Start date cannot be in the future.
- `53008`: End date cannot be earlier than start date.
- `53009`: Education ID not found.
- `53010`: Invalid education ID. It must be a positive integer.

### Profile Employment (54000-54999)
- `54001`: Invalid profile_id. It must be a positive integer.
- `54002`: Profile does not exist.
- `54003`: Employer name is required.
- `54004`: Position is required.
- `54005`: Start date is required.
- `54006`: Start date cannot be in the future.
- `54007`: End date cannot be earlier than start date.
- `54008`: Employment ID not found.
- `54009`: Invalid employment ID. It must be a positive integer.

### Profile Property (55000-55999)
- `55001`: Invalid profile_id. It must be a positive integer.
- `55002`: Profile does not exist.
- `55003`: Property type is required.
- `55004`: Property value is required.
- `55005`: Property ID not found.
- `55006`: Invalid property ID. It must be a positive integer.

### Profile Saved For Later (56000-56999)
- `56001`: Invalid profile_id. It must be a positive integer.
- `56002`: Profile does not exist.
- `56003`: Saved profile ID is required and must be valid.
- `56004`: Saved profile does not exist.
- `56005`: A profile cannot save itself.
- `56006`: This profile has already been saved.
- `56007`: Invalid saved record ID. It must be a positive integer.
- `56008`: Saved record does not exist.

### Profile Search Preference (57000-57999)
- `57001`: Invalid profile_id. It must be a positive integer.
- `57002`: Profile does not exist.
- `57003`: Minimum age must be at least 18.
- `57004`: Maximum age must be greater than minimum age.
- `57005`: Invalid gender preference.
- `57006`: Search preference already exists for this profile.
- `57007`: Invalid search preference ID. It must be a positive integer.
- `57008`: Search preference record does not exist.

### Profile Favorites (58000-58999)
- `58001`: Invalid profile_id. It must be a positive integer.
- `58002`: Profile does not exist.
- `58003`: Favorite profile ID is required and must be valid.
- `58004`: Favorite profile does not exist.
- `58005`: A profile cannot favorite itself.
- `58006`: This profile has already been favorited.
- `58007`: Invalid favorite ID. It must be a positive integer.
- `58008`: Favorite record does not exist.
- `58009`: Invalid favorite status. It must be 0 or 1.
- `58010`: Favorite status is required.
- `58011`: Favorite status is already set to this value.
- `58012`: Invalid favorite ID. It must be a positive integer.
- `58013`: Favorite record does not exist.
- `58014`: Invalid id. It must be a positive integer.
- `58015`: Favorite record with specified ID does not exist.

### Profile Views (59000-59999)
- `59001`: Invalid profile_id. It must be a positive integer.
- `59002`: Profile does not exist.
- `59003`: Viewed profile ID is required and must be valid.
- `59004`: Viewed profile does not exist.
- `59005`: A profile is viewing itself.
- `59006`: At least one of profile_id, viewed_profile_id, or id must be provided.
- `59007`: Invalid id. It must be a positive integer.
- `59008`: View record with specified ID does not exist.
- `59009`: Viewed profile ID must be valid if provided.
- `59010`: Viewed profile does not exist.
- `59011`: A profile is viewing itself.
- `59012`: View date cannot be in the future.
- `59013`: Invalid id. It must be a positive integer.
- `59014`: View record with specified ID does not exist.

### Profile Contacted (60000-60999)
- `60001`: Invalid profile_id. It must be a positive integer.
- `60002`: Profile does not exist.
- `60003`: Contacted profile ID is required and must be valid.
- `60004`: Contacted profile does not exist.
- `60005`: A profile cannot contact itself.
- `60006`: Contact method is required.
- `60007`: At least one of profile_id, contacted_profile_id, or id must be provided.
- `60008`: Invalid id. It must be a positive integer.
- `60009`: Contact record with specified ID does not exist.
- `60010`: Contacted profile ID must be valid if provided.
- `60011`: Contacted profile does not exist.
- `60012`: A profile cannot contact itself.
- `60013`: Contact method cannot be empty if provided.
- `60014`: Contact date cannot be in the future.
- `60015`: Invalid id. It must be a positive integer.
- `60016`: Contact record with specified ID does not exist.

### Profile Family Reference (61000-61999)
- `61001`: Invalid profile_id. It must be a positive integer.
- `61002`: Profile does not exist.
- `61003`: Name is required.
- `61004`: Relationship is required.
- `61005`: Contact information is required.
- `61006`: Family reference ID not found.
- `61007`: Invalid family reference ID. It must be a positive integer.

### Profile Hobby Interest (62000-62999)
- `62001`: Invalid profile_id. It must be a positive integer.
- `62002`: Profile does not exist.
- `62003`: Hobby/interest name is required.
- `62004`: Hobby/interest ID not found.
- `62005`: Invalid hobby/interest ID. It must be a positive integer.

### Profile Lifestyle (53000-53999)
- `53001`: Invalid profile_id. It must be a positive integer.
- `53002`: Profile does not exist.
- `53004`: Lifestyle information already exists for this profile.
- `53005`: Either profile_id or id must be provided.
- `53006`: Invalid profile_lifestyle_id. It must be a positive integer.
- `53007`: Lifestyle record with specified ID does not exist.

### Profile Photo (64000-64999)
- `64001`: Invalid profile_id. It must be a positive integer.
- `64002`: Profile does not exist.
- `64003`: Photo URL is required.
- `64004`: Photo type is required.
- `64005`: Invalid photo type.
- `64006`: Photo ID not found.
- `64007`: Invalid photo ID. It must be a positive integer.
- `64008`: Cannot set more than one primary photo.

## General Guidelines for Error Handling

1. All procedures use SQLSTATE '45000' for custom errors
2. Each table/procedure group has a dedicated range of error codes
3. Error messages are descriptive and user-friendly
4. All errors are logged to the activity_log table
5. Error handling includes both SQL exceptions and custom validation errors
