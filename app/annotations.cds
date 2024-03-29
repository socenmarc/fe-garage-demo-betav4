using IncidentService as service from '../srv/incidentservice';

/** marc - hidding default buttons*/
annotate service.SafetyIncidents  with @Capabilities : { 
    InsertRestrictions : {
        $Type:'Capabilities.InsertRestrictionsType',
        Insertable : true
        
    },
    DeleteRestrictions : {
        $Type:'Capabilities.DeleteRestrictionsType',
        Deletable : true,
        
    },    
 } ;

/*  annotate service.SafetyIncidents.setHighPriority with @Common : { 
     SideEffects : {
         $Type:'Common.SideEffectsType',
         TargetProperties : [
             priority_code
         ],                     
     },     
  }; */
 
/** fi marc */

annotate service.SafetyIncidents with @(UI : {
    //basic list report annotations
    //the presentation variant defines a per default ascending sorting for the LR table
    //https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/Common.md#SortOrderType
    PresentationVariant                  : {
        SortOrder      : [{
            $Type    : 'Common.SortOrderType',
            Property : priority_code
        }],
        Visualizations : ['@UI.LineItem']
    },
    //the lineItem annotation defines the table columns for UI display of the annotated entity
    //https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/UI.md#LineItem
    //Table columns are defined by building blocks of type DataFieldAbstract
    //https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/UI.md#DataFieldAbstract
    LineItem                             : [
    {
        $Type : 'UI.DataField',
        Value : identifier,
    },
    {
        $Type                     : 'UI.DataField',
        Value                     : priority_code,
        Criticality               : priority.criticality,
        CriticalityRepresentation : #WithoutIcon,

    },
    {
        $Type : 'UI.DataField',
        Value : priority.descr
    },      
    {
        $Type : 'UI.DataField',
        Value : incidentStatus_code
    },
    {
        $Type : 'UI.DataField',
        Value : category_code
    },   
/*     {
        $Type : 'UI.DataField',
        Value : title
    }, */
    /** marc - for v4*/
    /** set priority button*/
    {
				$Type: 'UI.DataFieldForAction', 
				Label:'{i18n>setHighPriority}', 
				Action:'IncidentService.setHighPriority', 
                ![@UI.Hidden] : isHigh,
				Inline: true
	},
    /** set priority with comment button*/
    {
				$Type: 'UI.DataFieldForAction', 
				Label:'{i18n>setHighPriorityWithComment}', 
				Action:'IncidentService.setHighPriorityWithComment', 
                ![@UI.Hidden] : isHigh,
				Inline: true
	},    
    /** high priority comment*/
    {
				$Type: 'UI.DataFieldForAction', 
				Label:'{i18n>changePriority}', 
				Action:'IncidentService.changePriority', 
				Inline: true
	},     
    {
        $Type : 'UI.DataField',
        Value : setToHighComment
    },
    {
        $Type : 'UI.DataField',
        Value : isHigh
    },
    /** call wizard */    
    {
				$Type: 'UI.DataFieldForAction', 
				Label:'{i18n>createViaWizard}', 
				Action:'createViaWizard'
    },     
    /** marc - for v2*/
    {
				$Type: 'UI.DataFieldForAction', 
				Label:'{i18n>setHighPriorityv2}', 
				Action:'IncidentService.SafetyIncidents/setHighPriority', 
				Inline: true
			},            
    /** end marc */

    ],

    //the managed associations incidentStatus, category and priority provide a denormalized _code property to the root entity SafetIncidents
    //Documentation managed associations: https://cap.cloud.sap/docs/guides/domain-models#use-managed-associations
    //usage of aspect sap.common.codelist for the associated entities automatically provides value help support for the selection fields
    //the entity definitions can be found in file db/schema.cds
    //Documentation codelists: https://cap.cloud.sap/docs/cds/common#aspect-sapcommoncodelist
    SelectionFields                      : [
    incidentStatus_code,
    category_code,
    priority_code
    ],

    //	Information for the header area of an entity representation
    HeaderInfo                           : {
        TypeName       : '{i18n>Incident}',
        TypeNamePlural : '{i18n>Incidents}',
        TypeImageUrl   : 'sap-icon://alert',
        Title          : {Value : title}
    },

    //Facets for additional object header information (shown in the object page header)
    HeaderFacets                         : [{
        $Type  : 'UI.ReferenceFacet',
        Target : '@UI.FieldGroup#HeaderGeneralInformation'
    }],

    //Group of fields with an optional label
    //https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/UI.md#FieldGroupType
    FieldGroup #HeaderGeneralInformation : {Data : [
    {Value : priority_code},
    {Value : priority.descr},
    {Value : incidentStatus_code},
    {Value : category_code},
    {
        $Type  : 'UI.DataFieldForAnnotation',
        Target : 'assignedIndividual/@Communication.Contact',
        Label  : '{i18n>AssignedContact}'
    }
    ]},

    FieldGroup #IncidentDetails          : {Data : [
    {
        $Type : 'UI.DataField',
        Value : identifier,
    },
    {
        $Type : 'UI.DataField',
        Value : title
    },
    {
        $Type : 'UI.DataField',
        Value : description
    },
    ]},

    FieldGroup #GeneralInformation       : {Data : [
    {
        $Type : 'UI.DataField',
        Value : priority_code
    },
    {
        $Type : 'UI.DataField',
        Value : setToHighComment
    },    
    {
        $Type : 'UI.DataField',
        Value : category_code
    },
    {
        $Type : 'UI.DataField',
        Value : incidentStatus_code
    }
    ]},

    //begin of field group enhancement
    FieldGroup #AdminData                : {
        $Type : 'UI.FieldGroupType',
        Data  : [
        {
            $Type : 'UI.DataField',
            Value : createdAt,
        },
        {
            $Type : 'UI.DataField',
            Value : createdBy,
        },


        ],

    },


    //end of field group enhancement

    //object page content area is organized by facets referring to e.g. fieldgroup and lineItem annotations
    //https://github.com/SAP/odata-vocabularies/blob/master/vocabularies/UI.md#Facet
    Facets                               : [
    {
        $Type  : 'UI.CollectionFacet',
        Label  : '{i18n>IncidentOverview}',
        ID     : 'IncidentOverviewFacet',
        Facets : [
            {
                $Type  : 'UI.ReferenceFacet',
                Label  : '{i18n>GeneralInformation}',
                ID     : 'IncidentDetailsFacet',
                Target : '@UI.FieldGroup#IncidentDetails'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                Label  : '{i18n>GeneralInformation}',
                ID     : 'GeneralInformationFacet',
                Target : '@UI.FieldGroup#GeneralInformation'
            },

            //begin of reference facet enhancement
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#AdminData',
                Label  : '{i18n>AdminData}',
                ID     : 'AdminDataFacet',
            },


        //end of reference facet enhancement
        ]
    },
    //this facet shows a table on the object page by referring to a lineItem annotation via association incidentFlow
    //the referred LineItem annotation definition for entity IncidentFlow is defined below
    {
        $Type         : 'UI.ReferenceFacet',
        Label         : '{i18n>IncidentProcessFlow}',
        ID            : 'ProcessFlowFacet',
        Target        : 'incidentFlow/@UI.LineItem',
        ![@UI.Hidden] : isDraft
    }

    ]
});

annotate service.IncidentFlow with @(UI : {LineItem : [

//begin of column enhancement
{
    $Type       : 'UI.DataField',
    Value       : stepStatus,
    Criticality : criticality,

},

//end of column enhancement
{
    $Type : 'UI.DataField',
    Value : processStep
},
{
    $Type : 'UI.DataField',
    Value : stepStartDate
},
{
    $Type : 'UI.DataField',
    Value : stepEndDate
},
{
    $Type : 'UI.DataField',
    Value : safetyIncident.assignedIndividual.fullName,
    Label : '{i18n>CreatedBy}'
}
]});
