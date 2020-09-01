using scp.cloud from '../db/schema';

service IncidentService{

    @odata.draft.enabled
    entity SafetyIncidents         as projection on cloud.SafetyIncidents
    /** marc */
        actions {
            action setHighPriority()       returns SafetyIncidents;
        }
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
