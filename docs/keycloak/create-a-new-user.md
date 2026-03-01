# Manually create a new user
This is a step-by-step guide on how to create a new user and also the workflow connected to it.

The required steps in user-creation:
* Create a user
* Set a temporary password
* Send confirmation email

## Create a user
In order to create a new user, an **admin account** is required which is used for the Keycloak admin realm.

Head to the **admin realm** and log in: https://auth.pub.solar/admin/master/console/#/pub.solar

Navigate to the **users**-section (burger menu -> users) or https://auth.pub.solar/admin/master/console/#/pub.solar/users

Click `Add user`, which will open the "Create user" dialogue.

Settings that need to be adjusted:
* Email verified: needs to be set to `true`
* Username: enter the requested username
* Email: enter the provided email-address

Click the `Save` button at the bottom.

## Set a temporary password
Click `Credentials` from the tab menu.
Click `Set password` (CTA in the center)

Fill the password input with a string generated locally.
Use this command to generate the string:
```bash
openssl rand -hex 24
```

The "Temporary" option must be set to `false`

## Send confirmation email
The final step is to inform the user that their account has been created.

Use these email templates (German / English) and fill the gaps
* USERNAME
* CREWMEMBER who is handling the task

### German
```
Hi <#### USERNAME ####>,

wir haben eine neue pub.solar ID für Dich erstellt. Bitte setze als erstes dein Passwort zurück, um den Account zu nutzen.
Um das Passwort zurückzusetzen, klicke bitte auf https://auth.pub.solar, gib deinen Nutzernamen ein und klicke auf "Anmelden".
Als nächstes klicke bitte auf "Passwort vergessen?" und folge der Anleitung in der zugesandten E-Mail.

Beste Grüße
@<#### CREWMEMBER ####> für die pub.solar crew
```

### English
```
Hi <#### USERNAME ####>,

Your new account is ready to use. Please reset the password to start using it.
To reset the password, go to https://auth.pub.solar then enter your new username.
Next, click "Forgot Password?" and follow the instructions in the email to reset your password.

Best,

@<#### CREWMEMBER ####> for the pub.solar crew
```
