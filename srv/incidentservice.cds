using scp.cloud from '../db/schema';

service IncidentService{

     /*        @cds.odata.bindingparameter.name : '_it'
            @Common : {
                IsActionCritical : true,
                SideEffects : {
                    TargetProperties : [ 'it_/priority_code']
                }
            }   
             */

    @odata.draft.enabled
    entity SafetyIncidents         as projection on cloud.SafetyIncidents
    /** marc */
        actions {
            @cds.odata.bindingparameter.name : '_it'
            @Common.SideEffects : {
                TargetProperties : ['_it/priority_code','_it/isHigh']
            }                       
            action setHighPriority()                                       returns SafetyIncidents;
            @cds.odata.bindingparameter.name : '_it'
            @Common.SideEffects : {
                TargetProperties : ['_it/priority_code','_it/setToHighComment','_it/isHigh']
            }               
            action setHighPriorityWithComment(
                @(UI.ParameterDefaultValue: 'default comment' )
                comment : String(500))       returns SafetyIncidents;
            @cds.odata.bindingparameter.name : '_it'
            @Common.SideEffects : {
                TargetProperties : ['_it/priority_code','_it/setToHighComment','_it/isHigh']
            }                  
            action changePriority(
            @(
                UI.Hidden : false,
                title     : 'Change Priority',
                Common    : {
                    FieldControl     : #Mandatory,
                    ValueListWithFixedValues,
                    ValueListMapping : {
                        CollectionPath : 'Priority',
                        Parameters     : [
                        {
                            $Type             : 'Common.ValueListParameterInOut',
                            LocalDataProperty : 'priority',
                            ValueListProperty : 'code',
                        },
                        {
                            $Type             : 'Common.ValueListParameterDisplayOnly',
                            ValueListProperty : 'descr'
                        }
                        ]
                    }
                }
            )
            priority : String not null);            
        }
        action createViaWizard()      returns SafetyIncidents;
    /** end marc */

    @readonly
    entity IncidentFlow            as projection on cloud.IncidentFlow;

    @readonly
    entity IncidentProcessTimeline as projection on cloud.IncidentProcessTimeline;

    @readonly
    entity Individual              as projection on cloud.Individual;

    @readonly
    entity Category                as projection on cloud.Category;

    @readonly
    entity Priority                as projection on cloud.Priority;
}
