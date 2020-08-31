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
    srv.after("READ", "SafetyIncidents", setPriorityCriticality);
    srv.before("SAVE", "SafetyIncidents", validateSafetyIncident);
    
    /** Marc */
    srv.before("SAVE", "SafetyIncidents", messageSafetyIncident);
    srv.on("setHighPriority", "SafetyIncidents", setHighPriority)

    function messageSafetyIncident(req) {
        req.info ({
            code: 400,
            message: 'Some Custom Error Message',
            target: 'some_field'
          })
    };

    function setHighPriority() {
        console.log('The incident is:', req.params[0].ID)
        
    }

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