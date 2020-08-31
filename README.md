# Beta program for SAP Fiori elements floorplans for OData V4

## ***Sample scenario: Incident Management***

### **Overview**

This sample scenario consists of a CAP/nodeJS based OData service with draft support and a basic set of UI annotations.
Based on it, you will create a simple List Report / Object Page Fiori elements application, and enhance it with additional functionality by making usage of the different Fiori Tools.

### **Installation Guide for Guided Beta**

* For installation of VSCode and setting up the SAP Fiori Tools, follow the installation guide [as described here](https://help.sap.com/viewer/product/SAP_FIORI_tools/DEVExternalBeta/en-US)
* Make sure to have the beta features enabled after installation of the VSCode extensions [as described here](https://help.sap.com/viewer/4b835ca4e369425fb000da2c3c37911b/DEVExternalBeta/en-US/7c755a5e7f914c2f816e5a6e28cf377c.html)
* **Note**: if you already have the VSCode extension "SAP Cloud Platform core data services plug-in for Visual Studio Code" you need to disable it as long as you work with the downloaded beta version. This is only needed during the beta phase, as the beta version is actually the same extension enhanced with the annotation LSP features.

### **Step 1: Create the app via the SAP Fiori Tools - Application Generator**

* In VS Code, select menu View -> Command Palette...
* In the dialog dropdown, search for 'SAP Fiori Tools - Application Generator - Launch' and select it
* The application generation wizard opens in a separate tab
* Dialog Step 'Select Generator':
  * Choose "SAP Fiori elements application and press 'Next'
* Dialog Step 'Template Selection':
  * Choose 'List Report Object Page V4' and press 'Next'
* 'Dialog Step 'Datasource and Service Selection':
  * Dropdown 'Select your data source': choose 'Use a local CAP Project'
  * Click folder icon in field 'Please select a CAP project folder.
  * Select the root folder of the currently opened CAP service project
  * Dropdown 'select OData service': choose 'IncidentService'
  * Press 'Next'
* Dialog Step 'Entity Selection'
  * Dropdown 'Enter the Main Entity of your choice', choose 'SafetyIncidents'
  * Dropdown 'Enter the navigation entity of your choice: leave to 'None'
  * Press 'Next'
* Dialog Step 'Project Attributes':
  * Enter the following values:
    * What is the module name for your application? incidents (if this doesn't match the custom page won't load later on)
    * What is the title for your application? My Incidents
    * What is the namespace for your application? sap.fe.demo (if this doesn't match the custom page won't load later on)
  * Option 'Do you want to configure advanced options':
    * toggle to 'Yes'
  * Option 'Select the UI5 version:' 
    * select 1.80.1
  * Option 'Skip generation of associated annotations.cds file'
    * Toggle to 'Yes'
* Press 'Next' to generate the application

### **Review the generated artifacts**

* check content in generated folder app/incidents

### **Review basic set of UI annotations in annotations.cds file in app folder**

* file app/annotation.cds already comes prepared with the service, allowing to show UI content directly after app generation
* Please refer to the [annotation UI vocabulary](https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/UI.md)

### **Step 2: start the app in browser**

* in the VS Code console, run 'cds watch'
* click on the shown url (localhost:4004)
* In the opened browser window, click the served index.html
* in the displayed FLP page, start the app by click the tile
* Press button 'Go'
* Select one LR entry to navigate to object page
* Press 'Edit'
* Change some values, e.g. priority, description
* Note that after each change the bottom toolbar shows 'Draft saved' notification once the input field focus is changed
* Navigate back to LR page. The previsouly edited incident now contains a draft indicator in the first column

### **Step 3: Disable Editable Header Content**

* On Object Page, when switching to edit mode the header fields are shown as editable.
* Since they appear also in the content area, we can set the header area to non-editable
* Open the Page Map:
  * In VSCode Explorer, click right mouse button on app folder and choose 'Show Page Map'
  * Alternatively, choose 'Application Modeller - Show Page Map' via Command Palette
  * Page Map is opened in a separate tab, showing pages and navigations
* Press the pencil button on the object page rectangle
* In the opened page editor:
  * Click on Object page -> header to open the properties panel
  * Set property "editableHeaderContent' to false
  * Refresh browser window
  * Select one LR entry and click 'Edit' on object page. Header fields are now shown display only

### **Step 4: add existing custom page**

* Copy existing custom page before adding it via page map tool
  * in Explorer, expand folder app/incidents/webapp
  * Go to folder app/test-resources
  * Copy folder 'ext' to app/incidents/webapp vith drag & ctrl+drop
* Examine the file content of ext folder (view and controller code)
* Open page map as described in step 4
* Press '+' on the object page rectangle
* Select page type 'custom page' from the first drop down
* Select navigation entity 'incidentFlow'
* Select 'Use Existing View'
* Check that the View Name drop down has 'ProcessFlow' selected
* Click 'Add'
* Show added page in page map
* Refresh browser
* Select a Process Flow table line to navigate to process flow custom page

### **Step 5: add existing custom section**

* Prerequisite: prepared XML fragment and js handler is available in folder app/incidents/webapp/ext (done with step 4)
* Show/explain the XML fragment content in app/incidents/webapp/ext/fragment
* Open page map as described in step 4
* Press the pencil button on the object page rectangle
* In the opened Page Editor:
  * Expand 'sections'
  * Hover in the top right corner of 'sections', press '+' button
* In the 'Add Custom Section' dialog:
  * Enter the title 'Maximum Processing Time'
  * Make sure that view type is set to 'fragment'
  * toggle radio buttons to 'Use Existing Fragment'
  * Check that the fragment name dropdown has 'CustomSectionGantt' selected
  * In 'Target Facet Section' dropdown, select 'IncidentOverviewFacet'
  * Make sure the radio button below is set to 'After'
  * Click 'Add'
  * Back in the page editor, show the added custom section under 'sections'
  * Refresh Browser to show the added custom section on the OP

### **Step 6a: UI annotations: add admin data field group**

Prerequisite: CDS compiler with LSP support installed as described in the setup section. Alternatively you can add the prepared annotation snippet via ctrl+space -> Betatest: Add Field Group.  You can use Format Document (Shift+Alt+F) to format code for better readibility.

* Open file app/annotation.cds
* Place cursor below comment '//begin of field group enhancement'
* Trigger LSP support with ctrl+space
* Type *field* to filter the list of options
* Choose UI.FieldGroup. Annotation is added along with its basic structural elements. Cursor is placed between 'Fieldgroup' and ':'
* Type #AdminData to add a qualifier
* Press tab to move cursor inside the curly brackets
* Trigger LSP support with ctrl+space
* Select Property "Data". Property Data is added, cursor is moved inside the collection []

```js
FieldGroup #AdminData: {
    $Type:'UI.FieldGroupType',
    Data : [

        ],
},
```

* Trigger LSP support with ctrl+space
* Select Record "DataField" from the drop down. DataField record ia added along with its required value. Cursor is placed inside the record {}
* Trigger LSP support with ctrl+space
* Type in *cr* to filer the list and select property 'createdAt'

```js
FieldGroup #AdminData: {
    $Type:'UI.FieldGroupType',
    Data : [
        {
            $Type:'UI.DataField',
            Value : createdAt,
        },

        ],

},
```

* Place the cursor after the record {}, and add additional DataField record with Value'createdBy' (use LSP as in previous step) 

### **Step 6b: UI annotations: add admin data reference facet**

Prerequisite: CDS compiler with LSP support installed as described in the setup section. * Alternatively you can add the prepared annotation snippet via ctrl+space -> Betatest: Add Facet.  You can use Format Document (Shift+Alt+F) to format code for better readibility.

* Open file [app/annotation.cds](app/annotations.cds)
* Place cursor below comment '//begin of reference facet enhancement'
* Trigger LSP support with ctrl+space
* Choose 'Record (full) "ReferenceFacet"'
**Note**: you can filter the list of values by typing a few characters, for example *ref*
* Trigger LSP support with crtl+space and select '@UI.Fieldgroup#AdminData'
* Press Tab to move cursor to the Label property, type ' ' or use ctrl-space to add it
* Type {i18n>AdminData} inside the quotes ' '
* Press Tab to move to ID property. 
* Add quotes '' and type 'AdminDataFacet' inside it.

```js
{
    $Type:'UI.ReferenceFacet',
    Target :  '@UI.FieldGroup#AdminData',
    Label : '{i18n>AdminData}',
    ID : 'AdminDataFacet',
},
```

* Save
* Refresh browser window with the App Preview and navigate to the ObjectPage: in the Incident Overview section, a new subsection "Admin Data" has been added. It contains the fields "created On" and "Created By" defined in the Field Group annotation.

### **Step 6c: UI annotations: add column to incident flow table**

* Prerequisite: CDS compiler with LSP support installed as described in the setup section. Alternatively you can add the prepared annotation snippet via ctrl+space -> Betatest: Add Column.  You can use Format Document (Shift+Alt+F) to format code for better readibility 
* Open annotations.cds in folder app/incidents
* Place cursor below comment '//begin of column enhancement'
* Trigger LSP support
* Choose 'Record "DataField"'
* Result:

  ```js
  {
    $Type:'UI.DataField',
    Value : ,
  },
  ```

* Trigger LSP at 'Value :' and choose stepStatus
* Save
* Refresh browser window: table columns 'Step Status' has been added
* Add an empty line after 
  * Value : stepStatus,
* Trigger LSP support
* Choose 'Property "Criticality"'
* Trigger LSP support
* choose entity property 'criticality'
* Result:

*

```js
{
    $Type:'UI.DataField',
    Value : stepStatus,
    Criticality : criticality,  
},
```

**Note**:  Format annotations for better readibility (Win: Shift+Alt+F, Mac: Shift+Option+F)

* Save
* Refresh browser window: table columns Step Status now shows a criticality color

### **Ressources**

* [official CAP documentation](https://cap.cloud.sap/docs/)
* [CAP learning journey](https://help.sap.com/doc/221f8f84afef43d29ad37ef2af0c4adf/HP_2.0/en-US/972e35035f404685ba6bb54b03f7c167.html)
* [CAP -Serving Fiori UIs](https://cap.cloud.sap/docs/guides/fiori#fiori-annotations)
* [Annotations Overview](https://cap.cloud.sap/docs/cds/odata-annotations)
* [RAP - Defining UI annotations](https://help.sap.com/viewer/923180ddb98240829d935862025004d6/Cloud/en-US/fd95e7c9905e469bb176217f49e15e71.html)
