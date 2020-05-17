CREATE SCHEMA administration;

CREATE SCHEMA basic;

CREATE SCHEMA clinic;

CREATE SCHEMA relief;

CREATE TABLE administration.internationorganization ( 
	id                   serial  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	CONSTRAINT pk_internationorganization_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE administration.internationorganization IS 'معلومات عن المنظمات الدولية الداعمة\nICRC,DRC,UNHCR,...etc';

CREATE TABLE administration.organizaiton ( 
	id                   serial  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	telephone            varchar(10)   ,
	address              varchar(100)   ,
	hq_city              varchar(100)   ,
	CONSTRAINT pk_organizaiton_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE administration.organizaiton IS 'توفير معلومات عن المنظمة التي تدير العمليات الإغاثية';

COMMENT ON COLUMN administration.organizaiton.hq_city IS 'The location of the headquarters of the organization';

CREATE TABLE administration.region ( 
	id                   serial  NOT NULL ,
	name                 varchar(20)   ,
	parent_id            integer   ,
	"level"              integer DEFAULT 0  ,
	CONSTRAINT pk_region_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE administration.region IS 'معلومات عن التقسيمات الإدارية السورية';

CREATE TABLE administration.roles ( 
	id                   serial  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	CONSTRAINT pk_roles_id PRIMARY KEY ( id )
 );

CREATE TABLE administration.subbranch ( 
	name                 varchar(100)  NOT NULL ,
	id                   serial  NOT NULL ,
	organization_id      integer  NOT NULL ,
	parent_id            integer   ,
	telephone            varchar(10)   ,
	subbranch_city       varchar(20)   ,
	address              varchar(100)   ,
	CONSTRAINT pk_subbranch_id PRIMARY KEY ( id, organization_id ),
	CONSTRAINT unq_subbranch_organization_id UNIQUE ( organization_id, id ) 
 );

COMMENT ON TABLE administration.subbranch IS 'توفير معلومات عن الأفرع التابعة لهذه المنظمة،\nفي حال كانت المنظمة لا تمتلك أفرع،\n يتم إدراج فرع واحد فقط تتطابق معلوماته معلومات المنظمة';

CREATE TABLE administration.users ( 
	id                   serial  NOT NULL ,
	username             varchar(100)  NOT NULL ,
	organization_id      integer   ,
	subbranch_id         integer   ,
	secret               varchar(255)  NOT NULL ,
	CONSTRAINT pk_users_id PRIMARY KEY ( id ),
	CONSTRAINT idx_users UNIQUE ( username, organization_id, subbranch_id ) 
 );

CREATE TABLE administration.user_roles ( 
	user_id              integer  NOT NULL ,
	role_id              integer  NOT NULL 
 );

CREATE TABLE basic.chronic_desciption ( 
	status_id            serial  NOT NULL ,
	status_name          varchar(50)  NOT NULL ,
	code                 varchar(5)  NOT NULL ,
	CONSTRAINT pk_chronic_desciption_status_id PRIMARY KEY ( status_id )
 );

COMMENT ON TABLE basic.chronic_desciption IS 'توصيف الأمراض المزمنة';

CREATE TABLE basic.family ( 
	family_id            serial  NOT NULL ,
	card_number          integer   ,
	giving_date          date   ,
	is_woman_lead        bool DEFAULT false  ,
	CONSTRAINT pk_family_id PRIMARY KEY ( family_id )
 );

COMMENT ON TABLE basic.family IS 'تجميع الأفراد ضمن أسرة';

CREATE TABLE basic.person ( 
	person_id            serial  NOT NULL ,
	organization_id      integer  NOT NULL ,
	subbranch_id         integer  NOT NULL ,
	family_id            integer   ,
	first_name           varchar(20)  NOT NULL ,
	father_name          varchar(20)  NOT NULL ,
	last_name            varchar(20)  NOT NULL ,
	mother               varchar(20)  NOT NULL ,
	fingerprint          bytea   ,
	landline             varchar(8)   ,
	cellphone            varchar(10)   ,
	address_extra_info   text   ,
	family_card_number   bigint  NOT NULL ,
	studies              integer   ,
	health_record        text   ,
	birth_date           date  NOT NULL ,
	family_position      integer   ,
	national_number      bigint   ,
	is_family_head       bool DEFAULT false  ,
	is_alive             bool DEFAULT true NOT NULL ,
	neighborhood         integer  NOT NULL ,
	carrier              varchar(100)   ,
	salary               integer   ,
	place_of_work        varchar(100)   ,
	CONSTRAINT pk_person_id PRIMARY KEY ( person_id, subbranch_id, organization_id ),
	CONSTRAINT unq_person_person_id UNIQUE ( person_id ) ,
	CONSTRAINT unq_person_person_id_0 UNIQUE ( person_id, organization_id, subbranch_id ) 
 );

COMMENT ON TABLE basic.person IS 'معلومات عن الفرد المكون للأسرة';

CREATE TABLE basic."zone" ( 
	person_id            integer  NOT NULL ,
	card_number          integer  NOT NULL ,
	zone_name            text   ,
	village              text   ,
	organization_id      integer  NOT NULL ,
	subbranch_id         integer  NOT NULL ,
	CONSTRAINT idx_zone PRIMARY KEY ( person_id, card_number, organization_id, subbranch_id )
 );

CREATE TABLE basic.displacement ( 
	person_id            integer  NOT NULL ,
	region_id            integer  NOT NULL ,
	"date"               date  NOT NULL ,
	organization_id      integer  NOT NULL ,
	subbranch_id         integer  NOT NULL ,
	CONSTRAINT pk_displacement_id PRIMARY KEY ( region_id, person_id, "date", organization_id, subbranch_id )
 );

COMMENT ON TABLE basic.displacement IS 'توصيف نزوح الفرد والأسرة\nيمكن أن يكون للفرد أو الأسرة أكثر من عملية نزوح واحدة';

CREATE TABLE basic.health_status ( 
	person_id            integer  NOT NULL ,
	status_id            integer  NOT NULL ,
	notes                varchar(50)   ,
	organization_id      integer  NOT NULL ,
	subbranch_id         integer  NOT NULL ,
	CONSTRAINT pk_health_status_status_id PRIMARY KEY ( status_id, person_id, organization_id, subbranch_id )
 );

CREATE TABLE clinic.clinics ( 
	clinic_id            serial  NOT NULL ,
	clinic_name          varchar(20)  NOT NULL ,
	CONSTRAINT pk_clinics_clinic_id PRIMARY KEY ( clinic_id )
 );

COMMENT ON TABLE clinic.clinics IS 'معلومات عن العيادات';

CREATE TABLE clinic.disease ( 
	disease_id           serial  NOT NULL ,
	disease_code         varchar(20)  NOT NULL ,
	disease_name         varchar(40)   ,
	CONSTRAINT pk_disease_disease_id PRIMARY KEY ( disease_id )
 );

COMMENT ON TABLE clinic.disease IS 'الأمراض';

CREATE TABLE clinic.doctor ( 
	doctor_id            serial  NOT NULL ,
	first_name           varchar(20)   ,
	last_name            varchar(20)  NOT NULL ,
	clinic_id            integer  NOT NULL ,
	CONSTRAINT pk_doctor_doctor_id PRIMARY KEY ( doctor_id, clinic_id ),
	CONSTRAINT unq_doctor_clinic_id UNIQUE ( clinic_id, doctor_id ) ,
	CONSTRAINT unq_doctor_doctor_id UNIQUE ( doctor_id ) 
 );

COMMENT ON TABLE clinic.doctor IS 'معلومات عن الأطباء';

CREATE TABLE clinic.medicine ( 
	medicine_id          serial  NOT NULL ,
	"medicine-name"      varchar(40)  NOT NULL ,
	medicine_calibre     varchar(20)  NOT NULL ,
	medicine_form        integer  NOT NULL ,
	active_material      varchar(40)  NOT NULL ,
	code                 varchar(3)  NOT NULL ,
	CONSTRAINT pk_medicine_medicine_id PRIMARY KEY ( medicine_id ),
	CONSTRAINT unq_medicine_code UNIQUE ( code ) 
 );

COMMENT ON TABLE clinic.medicine IS 'معلومات عن الادوية';

CREATE TABLE clinic.shipment ( 
	shipment_id          serial  NOT NULL ,
	shipment_date        date  NOT NULL ,
	shipment_source_id   integer   ,
	CONSTRAINT pk_shipment_shipment_id PRIMARY KEY ( shipment_id )
 );

COMMENT ON TABLE clinic.shipment IS 'شحن الدواء';

CREATE TABLE clinic.visit ( 
	person_id            integer  NOT NULL ,
	organization_id      integer  NOT NULL ,
	subbranch_id         integer  NOT NULL ,
	visit_date           date  NOT NULL ,
	fee                  integer DEFAULT 0  ,
	visit_id             serial  NOT NULL ,
	CONSTRAINT pk_visit_visit_id PRIMARY KEY ( visit_id ),
	CONSTRAINT idx_visit UNIQUE ( person_id, organization_id, subbranch_id, visit_date ) 
 );

COMMENT ON TABLE clinic.visit IS 'معلومات عن الزيارات';

COMMENT ON COLUMN clinic.visit.fee IS 'الرسوم';

CREATE TABLE clinic.examination ( 
	examination_id       integer  NOT NULL ,
	visit_id             integer  NOT NULL ,
	doctor_id            integer  NOT NULL ,
	clinic_id            integer   ,
	CONSTRAINT pk_examination_examination_id PRIMARY KEY ( examination_id ),
	CONSTRAINT unq_examination_examination_id UNIQUE ( examination_id, visit_id ) 
 );

COMMENT ON TABLE clinic.examination IS 'معاينة';

CREATE TABLE clinic.examintation ( 
	examination_id       integer  NOT NULL ,
	visit_id             integer  NOT NULL ,
	doctor_id            integer  NOT NULL ,
	prescrition_id       integer  NOT NULL ,
	CONSTRAINT pk_examintation_examination_id PRIMARY KEY ( examination_id ),
	CONSTRAINT unq_examintation_prescrition_id UNIQUE ( prescrition_id ) 
 );

COMMENT ON TABLE clinic.examintation IS 'المعاينة';

CREATE TABLE clinic.pharmacy_stock ( 
	shipment_id          integer  NOT NULL ,
	medicine_id          integer  NOT NULL ,
	production_date      date  NOT NULL ,
	expiration_date      date  NOT NULL ,
	quantity             integer  NOT NULL ,
	current_quantity     integer  NOT NULL ,
	CONSTRAINT pk_shipment_item_item_id PRIMARY KEY ( shipment_id, medicine_id )
 );

COMMENT ON TABLE clinic.pharmacy_stock IS 'مخزن الصيدلية';

CREATE TABLE clinic.prescription ( 
	prescription_id      serial  NOT NULL ,
	examination_id       integer  NOT NULL ,
	"free"               bool   ,
	presreciptio_date    date DEFAULT current_date NOT NULL ,
	CONSTRAINT idx_prescription PRIMARY KEY ( prescription_id ),
	CONSTRAINT unq_prescription_prescription_id UNIQUE ( prescription_id ) 
 );

COMMENT ON TABLE clinic.prescription IS 'الوصفة(  يوضع بالجدول ادوية الوصفة )';

CREATE TABLE clinic.diagnosis ( 
	examination_id       serial  NOT NULL ,
	disease_id           integer  NOT NULL ,
	notes                varchar(600)   ,
	visit_id             integer  NOT NULL ,
	CONSTRAINT idx_diagnosis PRIMARY KEY ( examination_id, disease_id, visit_id )
 );

COMMENT ON TABLE clinic.diagnosis IS 'التشخيص (الأمراض)';

CREATE TABLE clinic.pharmacy_movement_out ( 
	movement_id          serial  NOT NULL ,
	movemnet_type        integer  NOT NULL ,
	movement_date        date   ,
	notes                varchar(100)   ,
	prescrition_id       integer   ,
	CONSTRAINT pk_pharmacy_movement_out_movement_id PRIMARY KEY ( movement_id )
 );

COMMENT ON TABLE clinic.pharmacy_movement_out IS 'movement_type: إعادة، إتلاف، صرف وصفة';

CREATE TABLE clinic.prescribed_medications ( 
	prescrition_id       integer  NOT NULL ,
	medicine_id          integer  NOT NULL ,
	dose                 varchar(100)  NOT NULL ,
	quantity             integer  NOT NULL ,
	CONSTRAINT idx_prescribed_medications PRIMARY KEY ( prescrition_id, medicine_id )
 );

COMMENT ON TABLE clinic.prescribed_medications IS 'أدوية الوصفة';

CREATE TABLE clinic.medicine_out ( 
	medicine_id          integer  NOT NULL ,
	shipment_id          integer  NOT NULL ,
	quantity             integer   ,
	movement_id          integer  NOT NULL ,
	CONSTRAINT idx_medicine_out PRIMARY KEY ( medicine_id, shipment_id, movement_id )
 );

COMMENT ON TABLE clinic.medicine_out IS 'الدواء المخرج';

CREATE TABLE relief.cobon_type ( 
	id                   serial  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	"prefix"             varchar(3)  NOT NULL ,
	is_active            bool DEFAULT true NOT NULL ,
	current_number       integer DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_cobon_type_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE relief.cobon_type IS 'نوع الكوبونات المتوفرة';

COMMENT ON COLUMN relief.cobon_type."prefix" IS 'من أجل ترقيم الكوبونات، لكل نوع آلية ترقيم مختلفة';

COMMENT ON COLUMN relief.cobon_type.is_active IS 'نطر كل فترة لتغير آلية الترقيم لتجنب التزوير، ولذلك نحتاج هذا الحقل ليوضح لنا\nإذا كان هذا النوع من الكوبونات فعال أم لا\nوفي حال أردنا إضافة كوبون غذائية بترقيم جديد\nلا داعي لتعديل ترقيم الكوبونات السابقة';

CREATE TABLE relief.extra_family_info ( 
	family_id            integer  NOT NULL ,
	total_family_income  double precision   ,
	residence_type       integer   ,
	residence_status     integer   ,
	iscanceled           bool DEFAULT false NOT NULL ,
	dateofcacenlation    date   ,
	dateofregister       date DEFAULT current_date  ,
	reason_for_cancelation text   ,
	CONSTRAINT pk_extra_family_info_family_id PRIMARY KEY ( family_id )
 );

CREATE TABLE relief.materials ( 
	materials_id         serial  NOT NULL ,
	internation_organization_id integer  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	unit                 varchar(20)  NOT NULL ,
	material_type        integer DEFAULT 0 NOT NULL ,
	CONSTRAINT pk_materials_materials_id PRIMARY KEY ( materials_id, internation_organization_id ),
	CONSTRAINT unq_materials_materials_id UNIQUE ( materials_id ) 
 );

COMMENT ON TABLE relief.materials IS 'يوفر معلومات عن المواد التي بمكن استخدامها في المركز الإغاثي\nحقل name يعطي اسم المادة\nunit وحدة القياس (سلة، قطعة(\nmaterial_type يعطي نوع المادة (غذائية، غير غذائية) قيممته الإفتراضية 0 تعني غذائية';

CREATE TABLE relief.non_food ( 
	person_id            integer  NOT NULL ,
	n_date               date   ,
	material_id          integer   ,
	subbranch_id         integer   ,
	organization_id      integer   ,
	CONSTRAINT unq_non_food_person_id UNIQUE ( person_id ) ,
	CONSTRAINT unq_non_food_person_id_0 UNIQUE ( person_id, subbranch_id, organization_id ) 
 );

CREATE TABLE relief.cobon ( 
	family_id            integer  NOT NULL ,
	person_id            integer  NOT NULL ,
	subbranch_id         integer  NOT NULL ,
	organization_id      integer  NOT NULL ,
	number_of_items      integer DEFAULT 1 NOT NULL ,
	cobon_id             integer  NOT NULL ,
	cobontype_id         integer  NOT NULL ,
	cobon_issue_stamp    timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	cobon_recieve_stamp  timestamp DEFAULT CURRENT_TIMESTAMP  ,
	CONSTRAINT idx_cobon PRIMARY KEY ( cobon_id, cobontype_id )
 );

COMMENT ON COLUMN relief.cobon.cobon_issue_stamp IS 'من أهم الحقول يوضح وقت وتاريخ قطع الكوبون';

COMMENT ON COLUMN relief.cobon.cobon_recieve_stamp IS 'يوضح تاريخ ووقت استلام المعونة';

CREATE TABLE relief.food ( 
	family_id            integer  NOT NULL ,
	f_date               date   ,
	material_id          integer   ,
	CONSTRAINT pk_food_family_id PRIMARY KEY ( family_id )
 );

CREATE TABLE relief.material_in_cobon ( 
	material_id          integer  NOT NULL ,
	internantional_organization_id integer  NOT NULL ,
	cobon_id             integer  NOT NULL ,
	cobon_type_id        integer  NOT NULL ,
	number_of_items      integer DEFAULT 1 NOT NULL ,
	CONSTRAINT idx_material_in_cobon PRIMARY KEY ( material_id, cobon_id, cobon_type_id, internantional_organization_id )
 );

ALTER TABLE administration.region ADD CONSTRAINT fk_region_region FOREIGN KEY ( parent_id ) REFERENCES administration.region( id );

ALTER TABLE administration.subbranch ADD CONSTRAINT fk_subbranch_organizaiton FOREIGN KEY ( organization_id ) REFERENCES administration.organizaiton( id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE administration.subbranch ADD CONSTRAINT fk_subbranch_subbranch FOREIGN KEY ( parent_id ) REFERENCES administration.subbranch( id ) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE administration.user_roles ADD CONSTRAINT fk_user_roles_roles FOREIGN KEY ( role_id ) REFERENCES administration.roles( id );

ALTER TABLE administration.user_roles ADD CONSTRAINT fk_user_roles_users FOREIGN KEY ( user_id ) REFERENCES administration.users( id );

ALTER TABLE administration.users ADD CONSTRAINT fk_users_subbranch FOREIGN KEY ( organization_id, subbranch_id ) REFERENCES administration.subbranch( organization_id, id );

ALTER TABLE basic.displacement ADD CONSTRAINT fk_displacement_region FOREIGN KEY ( region_id ) REFERENCES administration.region( id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE basic.displacement ADD CONSTRAINT fk_displacement_person FOREIGN KEY ( person_id, organization_id, subbranch_id ) REFERENCES basic.person( person_id, organization_id, subbranch_id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE basic.family ADD CONSTRAINT fk_family_extra_family_info FOREIGN KEY ( family_id ) REFERENCES relief.extra_family_info( family_id );

ALTER TABLE basic.health_status ADD CONSTRAINT fk_health_status_subbranch FOREIGN KEY ( person_id, organization_id, subbranch_id ) REFERENCES basic.person( person_id, organization_id, subbranch_id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE basic.health_status ADD CONSTRAINT fk_health_status FOREIGN KEY ( status_id ) REFERENCES basic.chronic_desciption( status_id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE basic.person ADD CONSTRAINT f_id FOREIGN KEY ( family_id ) REFERENCES basic.family( family_id );

ALTER TABLE basic.person ADD CONSTRAINT fk_person_region FOREIGN KEY ( neighborhood ) REFERENCES administration.region( id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE basic.person ADD CONSTRAINT fk_person_organizaiton FOREIGN KEY ( subbranch_id, organization_id ) REFERENCES administration.subbranch( id, organization_id );

ALTER TABLE basic."zone" ADD CONSTRAINT fk_zone_person FOREIGN KEY ( person_id, organization_id, subbranch_id ) REFERENCES basic.person( person_id, organization_id, subbranch_id );

ALTER TABLE clinic.diagnosis ADD CONSTRAINT fk_diagnosis_disease FOREIGN KEY ( disease_id ) REFERENCES clinic.disease( disease_id );

ALTER TABLE clinic.diagnosis ADD CONSTRAINT fk_diagnosis_examintation FOREIGN KEY ( examination_id, visit_id ) REFERENCES clinic.examination( examination_id, visit_id );

ALTER TABLE clinic.doctor ADD CONSTRAINT fk_doctor_clinics FOREIGN KEY ( clinic_id ) REFERENCES clinic.clinics( clinic_id );

ALTER TABLE clinic.examination ADD CONSTRAINT fk_examination_visit_id FOREIGN KEY ( visit_id ) REFERENCES clinic.visit( visit_id );

ALTER TABLE clinic.examination ADD CONSTRAINT fk_examination_doctor FOREIGN KEY ( doctor_id ) REFERENCES clinic.doctor( doctor_id );

ALTER TABLE clinic.examintation ADD CONSTRAINT fk_examintation_doctor FOREIGN KEY ( doctor_id ) REFERENCES clinic.doctor( doctor_id );

ALTER TABLE clinic.examintation ADD CONSTRAINT fk_examintation_visit FOREIGN KEY (  ) REFERENCES clinic.visit(  );

ALTER TABLE clinic.medicine_out ADD CONSTRAINT fk_medicine_out_pharmacy_stock FOREIGN KEY ( medicine_id, shipment_id ) REFERENCES clinic.pharmacy_stock( medicine_id, shipment_id );

ALTER TABLE clinic.medicine_out ADD CONSTRAINT fk_medicine_out FOREIGN KEY ( movement_id ) REFERENCES clinic.pharmacy_movement_out( movement_id );

ALTER TABLE clinic.pharmacy_movement_out ADD CONSTRAINT fk_pharmacy_movement_out FOREIGN KEY ( prescrition_id ) REFERENCES clinic.prescription( prescription_id );

ALTER TABLE clinic.pharmacy_stock ADD CONSTRAINT fk_shipment_item_shipment FOREIGN KEY ( shipment_id ) REFERENCES clinic.shipment( shipment_id );

ALTER TABLE clinic.pharmacy_stock ADD CONSTRAINT fk_shipment_item_medicine FOREIGN KEY ( medicine_id ) REFERENCES clinic.medicine( medicine_id );

ALTER TABLE clinic.prescribed_medications ADD CONSTRAINT fk_prescribed_medications FOREIGN KEY ( medicine_id ) REFERENCES clinic.medicine( medicine_id );

ALTER TABLE clinic.prescribed_medications ADD CONSTRAINT fk_prescribed_medications_prescrtion FOREIGN KEY ( prescrition_id ) REFERENCES clinic.prescription( prescription_id );

ALTER TABLE clinic.prescription ADD CONSTRAINT fk_prescription_examination FOREIGN KEY ( examination_id ) REFERENCES clinic.examination( examination_id );

ALTER TABLE clinic.shipment ADD CONSTRAINT fk_shipment_internationorganization FOREIGN KEY ( shipment_source_id ) REFERENCES administration.internationorganization( id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE relief.cobon ADD CONSTRAINT fk_cobon_cobon_type FOREIGN KEY ( cobon_id ) REFERENCES relief.cobon_type( id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE relief.cobon ADD CONSTRAINT fk_cobon_extra_family_info FOREIGN KEY ( family_id ) REFERENCES relief.extra_family_info( family_id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE relief.cobon ADD CONSTRAINT fk_cobon_person FOREIGN KEY ( person_id, organization_id, subbranch_id ) REFERENCES basic.person( person_id, organization_id, subbranch_id );

ALTER TABLE relief.food ADD CONSTRAINT fk_food_materials FOREIGN KEY ( material_id ) REFERENCES relief.materials( materials_id );

ALTER TABLE relief.material_in_cobon ADD CONSTRAINT fk_material_in_cobon_cobon FOREIGN KEY ( cobon_id, cobon_type_id ) REFERENCES relief.cobon( cobon_id, cobontype_id );

ALTER TABLE relief.material_in_cobon ADD CONSTRAINT fk_material_in_cobon_materials FOREIGN KEY ( material_id, internantional_organization_id ) REFERENCES relief.materials( materials_id, internation_organization_id );

ALTER TABLE relief.materials ADD CONSTRAINT fk_materials_organizaiton FOREIGN KEY ( internation_organization_id ) REFERENCES administration.internationorganization( id ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE relief.non_food ADD CONSTRAINT fk_non_food_materials FOREIGN KEY ( material_id ) REFERENCES relief.materials( materials_id );

