namespace scp.cloud;
using {scp.cloud.identified, scp.cloud.TechnicalBooleanFlag, scp.cloud.TechnicalFieldControlFlag, scp.cloud.Criticality} from '../srv/common';

using {
  managed,
  cuid,
  sap.common
} from '@sap/cds/common';

type Url : String;

entity SafetyIncidents : managed, identified {
  title                  : String(50)                    @title : 'Title';
  category               : Association to one Category       @title : 'Category';
  priority               : Association to one Priority       @title : 'Priority';
  incidentStatus         : Association to one IncidentStatus @title : 'Incident Status';
  description            : String(1000)                  @title : 'Description';
  assignedIndividual     : Association to one Individual;
  incidentFlow         : Association to many IncidentFlow on incidentFlow.safetyIncident = $self;
  incidentProcessTimeline : Association to many IncidentProcessTimeline on incidentProcessTimeline.safetyIncident = $self;
  isDraft         : TechnicalBooleanFlag not null default false;
  identifierFieldControl : TechnicalFieldControlFlag not null default 7; // 7 = #Mandatory;
}

entity IncidentFlow : managed {
  key id : UUID;
  processStep: String(30) @title : 'Process Step';
  stepStatus: String(10) @title  : 'Process Step Status';
  criticality: Integer;
  stepStartDate: Date @title : '{i18n>StepStartDate}';
  stepEndDate: Date @title : '{i18n>StepEndDate}';
  safetyIncident : Association to SafetyIncidents;
}

entity IncidentProcessTimeline : managed {
  key id : UUID;
  text : String;
  type : String;
  startTime: DateTime;
  endTime: DateTime;
  safetyIncident : Association to SafetyIncidents;  
}

entity Individual : managed{
  Key ID : UUID;
  fullName    : String    @title : 'First Name';
  emailAddress : String    @title : 'Email Address';  
  safetyIncidents : Association to many SafetyIncidents on safetyIncidents.assignedIndividual = $self;
}

entity IncidentsCodeList : common.CodeList {
  key code : String(20);
}

entity Category : IncidentsCodeList {}

entity Priority : IncidentsCodeList {
  criticality: Criticality not null default 3;
}

entity IncidentStatus : IncidentsCodeList {}