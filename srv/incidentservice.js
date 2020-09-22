const cds = require("@sap/cds");

/**
 * Enumeration values for FieldControlType
 * @see https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/Common.md#FieldControlType
 */
const FieldControl = {
    Mandatory: 7,
    Optional: 3,
    ReadOnly: 1,
    Inapplicable: 0,
  };
  
module.exports = cds.service.impl(async function (srv) {
    const {
        SafetyIncidents
    } = srv.entities

    //read/edit event hook after read  of entity 'SafetyIncidents'
    srv.after(["READ", "EDIT"], "SafetyIncidents", setTechnicalFlags);
    srv.after("READ", "SafetyIncidents", setHighPriorityFlag);
    srv.after("READ", "SafetyIncidents", setPriorityCriticality);
    srv.before("SAVE", "SafetyIncidents", validateSafetyIncident);
    
    /** Marc */
    srv.before("SAVE", "SafetyIncidents", messageSafetyIncident);
    srv.on("setHighPriority", "SafetyIncidents", setHighPriority)
    srv.on("setHighPriorityWithComment", "SafetyIncidents", setHighPriorityWithComment)
    srv.on("createViaWizard", createViaWizard)

    function messageSafetyIncident(req) {
        req.info ({
            code: 400,
            message: 'Some Custom Error Message',
            target: 'some_field'
          })
    };

    async function createViaWizard(req) {
        console.log('Amazing button')
        req.notify('Amazing button')   
    }   

    async function setHighPriority(req) {
        return _setHighPriority(req)        
    }    

    async function setHighPriorityWithComment(req) {  
        const {comment} = req.data    
        return _setHighPriority(req, comment)        
    }    

    async function _setHighPriority (req,comment) {

        console.log('The incident is:', req.params[0].ID);
        const {ID} = req.params[0];

        const theIncident = await cds.read(SafetyIncidents, ID);

        console.log(theIncident.priority_code)

        if (theIncident.priority_code === "1"){
            req.error({
                code: "code2",
                message: 'Incident is high already',
                target: 'some_field'
            })
        } else {     
            
            //const result = await srv.update('SafetyIncidents', ID).with(`priority_code =`, '1')
            const tx = cds.transaction(req)
            const affectedRows = await tx.run (
              UPDATE (SafetyIncidents).set ('priority_code =', '1' ,'setToHighComment =', comment)
                                      .where ('ID=', ID)
            )        
            if ( affectedRows < 1) {
                req.error({
                    code: "code3",
                    message: 'Error updating priority',
                    target: 'some_field'
                })
            } else {
                req.info ({
                    code: "code1",
                    message: 'Priority updated'            
                })
                theIncident.priority_code = '1';
                console.log('bye')
                return theIncident; 
            }        
        }
        return theIncident;
    };

    //Set High Priority Flag
    function setHighPriorityFlag(safetyIncidents, req) {

        function _setFlags(safetyIncident) {
            safetyIncident.isHigh  = (safetyIncident.priority.code === '1'); //|| (safetyIncident.priority.code === '1');
        }

        //If priority is not requested, do not try to calculete isHigh
        if (req.query.SELECT.columns.filter(({ func }) => {
            return func === 'priority_code';
        }).length){
            return
        } 

        if (Array.isArray(safetyIncidents)) {
            safetyIncidents.forEach(_setFlags);
        } else {
            _setFlags(safetyIncidents);
        }
    };

    /** end Marc */

    /**
     * Set technical flags, used for controlling UI behaviour, on the 'SafetyIncidents' entity
     *
     * @param safetyIncidents {SafetyIncidents | SafetyIncidents[]}  (Array of) SafetyIncidents
     */
    function setTechnicalFlags(safetyIncidents) {

        function _setFlags(safetyIncident) {
            safetyIncident.isDraft = !safetyIncident.IsActiveEntity;

            // field control on the 'identifier' property
            if (safetyIncident.IsActiveEntity) {
                safetyIncident.identifierFieldControl = FieldControl.Optional;
            } else if (safetyIncident.HasActiveEntity) {
                safetyIncident.identifierFieldControl = FieldControl.ReadOnly;
            } else {
                safetyIncident.identifierFieldControl = FieldControl.Mandatory;
            }
        }

        if (Array.isArray(safetyIncidents)) {
            safetyIncidents.forEach(_setFlags);
        } else {
            _setFlags(safetyIncidents);
        }
    };

    /**
     * Set priority criticality used for display in LR table
     *
     * @param safetyIncidents {SafetyIncidents | SafetyIncidents[]}  (Array of) SafetyIncidents
     */
    function setPriorityCriticality(safetyIncidents) {

        function _setCriticality(safetyIncident) {
            if (safetyIncident.priority) {
                safetyIncident.priority.criticality = parseInt(safetyIncident.priority.code);
            }
        }

        if (Array.isArray(safetyIncidents)) {
            safetyIncidents.forEach(_setCriticality);
        } else {
            _setCriticality(safetyIncidents);
        }
    }

    /**
     * Validate a 'SafetyIncident' entry
     *
     * @param req   Request
     */
    function validateSafetyIncident(req) {
        // check mandatory properties
        if (!req.data.identifier) {
            req.error(400, "Enter a Safety Incident Identifier", "in/identifier");
        }
    }
})