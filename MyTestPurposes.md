# My Test purposes

## Based on colleagues tests:

- Inline editing/creation
    
    In manifest.json L107

                                "@com.sap.vocabularies.UI.v1.LineItem": {
                                    "tableSettings": {
                                        "creationMode": {
                                            "name": "Inline",
                                            "createAtEnd": false
                                        }
                                    }
                                }

- Supported DataFields:
    com.sap.vocabularies.UI.v1.DataFieldWithUrl
    com.sap.vocabularies.UI.v1.DataFieldForAnnotation
    com.sap.vocabularies.UI.v1.DataFieldWithNavigationPath
    com.sap.vocabularies.UI.v1.DataFieldForAction  (only with property Inline = true)
    com.sap.vocabularies.UI.v1.DataFieldForIntentBasedNavigation  (only with property Inline = true)
