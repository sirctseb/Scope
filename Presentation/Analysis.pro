<IMPRINTProDB>
	<xs:schema id="IMPRINTProDB" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:msprop="urn:schemas-microsoft-com:xml-msprop">
		<xs:element name="IMPRINTProDB" msdata:IsDataSet="true" msdata:UseCurrentLocale="true" msprop:SystemName="" msprop:Name="Analysis" msprop:MissionArea="" msprop:SystemType="" msprop:Folder_FK="Analyses" msprop:Version="1" msprop:Description="" msprop:dbVersion="3.0.1.3" msprop:ApplicationVersion="3.0.0.0">
			<xs:complexType>
				<xs:choice minOccurs="0" maxOccurs="unbounded">
					<xs:element name="activity">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="IsSleepable" type="xs:boolean" default="false" />
								<xs:element name="ForceUnit_FK" type="xs:int" />
								<xs:element name="IsPlanned" type="xs:boolean" default="true" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="analysispreferences">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="TimeFormatMission" type="xs:short" default="3" minOccurs="0" />
								<xs:element name="TimeFormatMaint" type="xs:short" default="2" minOccurs="0" />
								<xs:element name="StressorTempFormat" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="TaskBackgroundColor" default="Plum" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TaskBackgroundShape" type="xs:short" default="8" minOccurs="0" />
								<xs:element name="TaskSizeType" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="FunctionBackgroundColor" default="LightGray" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="FunctionBackgroundShape" type="xs:short" default="0" minOccurs="0" />
								<xs:element name="FunctionSizeType" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="GoalBackgroundColor" default="LightCoral" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="GoalBackgroundShape" type="xs:short" default="5" minOccurs="0" />
								<xs:element name="GoalSizeType" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="CommentBackgroundColor" default="LightYellow" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="CommentBackgroundShape" type="xs:short" default="0" minOccurs="0" />
								<xs:element name="CommentSizeType" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="WorkloadMonitorBackgroundColor" default="LightGreen" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="WorkloadMonitorBackgroundShape" type="xs:short" default="0" minOccurs="0" />
								<xs:element name="WorkloadMonitorSizeType" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="ScheduledFunctionBackgroundColor" default="LightBlue" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ScheduledFunctionBackgroundShape" type="xs:short" default="0" minOccurs="0" />
								<xs:element name="ScheduledFunctionSizeType" type="xs:short" default="1" minOccurs="0" />
								<xs:element name="Specialty" type="xs:short" default="0" minOccurs="0" />
								<xs:element name="OrgLevel1" default="Org" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="10" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="OrgLevel2" default="DS" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="10" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="OrgLevel3" default="GS" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="10" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="MissionReportsTimeFormat" type="xs:short" default="3" minOccurs="0" />
								<xs:element name="MaintReportsTimeFormat" type="xs:short" default="3" minOccurs="0" />
								<xs:element name="ForceTimeFormat" type="xs:short" default="5" minOccurs="0" />
								<xs:element name="ForceReportsTimeFormat" type="xs:short" default="2" minOccurs="0" />
								<xs:element name="UseCustomTraining" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="appliedcustomtrainingmx">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="RepairTask_FK" type="xs:int" />
								<xs:element name="CustomTrainingLevel_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="appliedcustomtrainingop">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="CustomTrainingLevel_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="appliedpersonneltraining">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Specialty_FK" type="xs:int" />
								<xs:element name="Operator_FK" type="xs:int" minOccurs="0" />
								<xs:element name="TrainingFrequency_FK" type="xs:unsignedByte" default="2" />
								<xs:element name="ASVABComposite_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="ASVABScore" type="xs:short" default="0" />
								<xs:element name="PreviousComposite_FK" type="xs:unsignedByte" />
								<xs:element name="PreviousScore" type="xs:short" />
								<xs:element name="MentalCategory_FK" type="xs:unsignedByte" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="appliedtaxonop">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="Taxon_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="Weight" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="appliedtaxonmx">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="MaintAction_FK" type="xs:unsignedByte" />
								<xs:element name="Taxon_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="Weight" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="applieduserstressormx">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="RepairTask_FK" type="xs:int" />
								<xs:element name="UserStressorLevel_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="applieduserstressorop">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="UserStressorLevel_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="chart">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Name" default="Chart">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ChartType" type="xs:string" default="Lines" />
								<xs:element name="EnableXAxisRange" type="xs:boolean" default="false" />
								<xs:element name="EnableYAxisRange" type="xs:boolean" default="false" />
								<xs:element name="XAxisMin" type="xs:double" default="0" />
								<xs:element name="XAxisMax" type="xs:double" default="999" />
								<xs:element name="YAxisMin" type="xs:double" default="0" />
								<xs:element name="YAxisMax" type="xs:double" default="999" />
								<xs:element name="AutomaticPlotting" type="xs:boolean" default="true" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="chartseries">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Chart_FK" type="xs:int" />
								<xs:element name="Name" default="Series">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="X" type="xs:string" default="Clock" />
								<xs:element name="Y" type="xs:string" default="Clock" />
								<xs:element name="Z" type="xs:string" default="" />
								<xs:element name="Color" type="xs:string" default="" />
								<xs:element name="Shape" type="xs:string" default="" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="comment">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Function_FK" type="xs:int" />
								<xs:element name="MSSharpID" type="xs:string" default="" />
								<xs:element name="Name" default="Comment">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Notes" type="xs:string" default="" />
								<xs:element name="XPos" type="xs:double" default="-1" />
								<xs:element name="YPos" type="xs:double" default="-1" />
								<xs:element name="Width" type="xs:double" default="65.79296" />
								<xs:element name="Height" type="xs:double" default="19.09114" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="commentvariable">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Variable_FK" type="xs:int" />
								<xs:element name="Comment_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="component">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Subsystem_FK" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="PartNumber" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="crewlimit">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Specialty_FK" type="xs:int" default="352" />
								<xs:element name="Scenario_FK" type="xs:int" minOccurs="0" />
								<xs:element name="Grade" type="xs:unsignedByte" default="10" />
								<xs:element name="ShiftNum" type="xs:int" default="0" />
								<xs:element name="ORGLimit" type="xs:int" default="0" />
								<xs:element name="DSLimit" type="xs:int" default="0" />
								<xs:element name="GSLimit" type="xs:int" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="culturaltemplate">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="culturaltemplateparameter">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Variable_FK" type="xs:int" />
								<xs:element name="CulturalTemplate_FK" type="xs:int" />
								<xs:element name="InitialValue" type="xs:string" default="" minOccurs="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="customtraining">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="customtraininglevel">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="CustomTraining_FK" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="AccuracyDefinition" type="xs:string" default="" minOccurs="0" />
								<xs:element name="TimeDefinition" type="xs:string" default="" minOccurs="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="forceunit">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="function">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" minOccurs="0" />
								<xs:element name="ParentFunction_FK" type="xs:int" minOccurs="0" />
								<xs:element name="MSSharpID" type="xs:string" default="" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TimeRequirement" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Scheduled" type="xs:boolean" default="false" />
								<xs:element name="StartTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="StopTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Criterion" type="xs:double" default="0" />
								<xs:element name="WorkloadManagementSuspended" type="xs:boolean" default="false" />
								<xs:element name="GoalOriented" type="xs:boolean" default="false" />
								<xs:element name="GoalPriority" type="xs:int" default="0" />
								<xs:element name="GoalInitiatingCondition" type="xs:string" default="return false;" />
								<xs:element name="GoalDescription" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="MissionRunning" type="xs:unsignedByte" default="1" />
								<xs:element name="Height" type="xs:double" default="0" />
								<xs:element name="Width" type="xs:double" default="0" />
								<xs:element name="XPos" type="xs:double" default="-1" />
								<xs:element name="YPos" type="xs:double" default="-1" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="goalaction">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="OwnerGoal_FK" type="xs:int" />
								<xs:element name="OtherGoal_FK" type="xs:int" />
								<xs:element name="OtherGoalRunning" type="xs:unsignedByte" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="interface">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="InterfaceCode_FK" type="xs:unsignedByte" />
								<xs:element name="Name" default="Interface">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="job">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ForceUnit_FK" type="xs:int" />
								<xs:element name="Rank_FK" type="xs:unsignedByte" default="1" />
								<xs:element name="Specialty_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="jobmanningtypemap">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="ManningType_FK" type="xs:unsignedByte" />
								<xs:element name="Job_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="manning">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="ManningType_FK" type="xs:unsignedByte" default="3" />
								<xs:element name="UnplannedActivity_FK" type="xs:int" />
								<xs:element name="NumberRequired" type="xs:short" default="0" />
								<xs:element name="NumberDesired" type="xs:short" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="mission">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="2000" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="SuccessProbability" type="xs:double" default="0" />
								<xs:element name="AccuracyCriterion" type="xs:double" default="0" />
								<xs:element name="TimeCriterion" type="xs:double" default="0" />
								<xs:element name="TimeRequirement" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="DateLastModified" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="20" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Scheduled" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="networktask">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Function_FK" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Type" type="xs:unsignedByte" default="1" />
								<xs:element name="MSSharpID" type="xs:string" default="" />
								<xs:element name="TimeRequirement" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="AccuracyRequirement" type="xs:double" default="0" />
								<xs:element name="AccuracyMeasure_FK" type="xs:unsignedByte" default="1" />
								<xs:element name="Criterion" type="xs:double" default="0" />
								<xs:element name="SuccessProbability" type="xs:double" default="100" />
								<xs:element name="DataShapingInputType" type="xs:unsignedByte" default="0" />
								<xs:element name="Distribution_FK" type="xs:unsignedByte" default="14" />
								<xs:element name="DataShaping1" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="DataShaping2" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="DataShaping3" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="DataShapingExpression" type="xs:string" default="return 0.0;" />
								<xs:element name="StartTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="StopTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="AccuracyMean" type="xs:double" default="0" />
								<xs:element name="AccuracyStdDev" type="xs:double" default="0" />
								<xs:element name="Priority" type="xs:double" default="3" />
								<xs:element name="InterruptStrategy" type="xs:int" default="2" />
								<xs:element name="ReleaseCond" type="xs:string" default="return true;" />
								<xs:element name="BeginningEffect" type="xs:string" default="" />
								<xs:element name="EndEffect" type="xs:string" default="" />
								<xs:element name="ProbDegradeTask" type="xs:double" default="0" />
								<xs:element name="DegradeTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="DegradeTime" type="xs:double" default="0" />
								<xs:element name="DegradeAcc" type="xs:double" default="0" />
								<xs:element name="ProbChangeTask" type="xs:double" default="0" />
								<xs:element name="ChangeTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="ProbFailMission" type="xs:double" default="0" />
								<xs:element name="ProbNoEffect" type="xs:double" default="100" />
								<xs:element name="ProbChangeOperator" type="xs:double" default="0" />
								<xs:element name="ChangeOperator_FK" type="xs:int" minOccurs="0" />
								<xs:element name="ChangeOperatorTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="ProbRepeatTask" type="xs:double" default="0" />
								<xs:element name="StressorMOPP_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorHeat_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorHumidity_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorCold_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorWind_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorSleepless_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorNoiseDistance_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorNoiseDb_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorVibrationFrequency_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorVibrationMagnitude_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="BranchingDecisionType" type="xs:unsignedByte" default="0" />
								<xs:element name="PreviousAccuracy" type="xs:double" default="0" />
								<xs:element name="CalculatedAccuracy" type="xs:double" default="0" />
								<xs:element name="PreviousTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="CalculatedTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="PreviousProbability" type="xs:double" default="0" />
								<xs:element name="CalculatedProbability" type="xs:double" default="0" />
								<xs:element name="Height" type="xs:double" default="0" />
								<xs:element name="Width" type="xs:double" default="0" />
								<xs:element name="XPos" type="xs:double" default="0" />
								<xs:element name="YPos" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="nodelink">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="SourceFunction_FK" type="xs:int" />
								<xs:element name="TargetTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="TargetFunction_FK" type="xs:int" minOccurs="0" />
								<xs:element name="XPosition" type="xs:double" default="0" />
								<xs:element name="YPosition" type="xs:double" default="0" />
								<xs:element name="PathPointsIn" type="xs:string" default="" />
								<xs:element name="PathPointsOut" type="xs:string" default="" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="operator">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Specialty_FK" type="xs:int" default="352" />
								<xs:element name="Automated" type="xs:boolean" default="false" />
								<xs:element name="IsDefaultOperator" type="xs:boolean" default="false" />
								<xs:element name="IsCrewMaintainer" type="xs:boolean" default="false" />
								<xs:element name="DefaultStrategy" type="xs:unsignedByte" default="0" />
								<xs:element name="TaskShedCriterionD" type="xs:unsignedByte" default="1" />
								<xs:element name="TaskShedCriterionE" type="xs:unsignedByte" default="0" />
								<xs:element name="Threshold" type="xs:int" default="60" />
								<xs:element name="PenaltyATime" type="xs:double" default="0" />
								<xs:element name="PenaltyAAcc" type="xs:double" default="0" />
								<xs:element name="PenaltyETime" type="xs:double" default="0" />
								<xs:element name="PenaltyEAcc" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="orglevel">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" type="xs:unsignedByte" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="path">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="SourceFunction_FK" type="xs:int" minOccurs="0" />
								<xs:element name="SourceTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="TargetFunction_FK" type="xs:int" minOccurs="0" />
								<xs:element name="TargetTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="Probability" type="xs:double" default="0" />
								<xs:element name="TacticalExpr" type="xs:string" default="return true;" />
								<xs:element name="MultipleExpr" type="xs:string" default="return true;" />
								<xs:element name="PathPoints" type="xs:string" default="" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="plugindata">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="PluginName">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="250" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Data" type="xs:base64Binary" minOccurs="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="repairtask">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Component_FK" type="xs:int" />
								<xs:element name="MaintAction_FK" type="xs:unsignedByte" />
								<xs:element name="IsCorrective" type="xs:boolean" default="false" />
								<xs:element name="Specialty1_FK" type="xs:int" default="352" />
								<xs:element name="Specialty1Grade" type="xs:unsignedByte" default="10" />
								<xs:element name="NumberOfSpecialty1" type="xs:int" default="1" />
								<xs:element name="Specialty2_FK" type="xs:int" minOccurs="0" />
								<xs:element name="Specialty2Grade" type="xs:unsignedByte" default="10" />
								<xs:element name="NumberOfSpecialty2" type="xs:int" default="0" />
								<xs:element name="StressorMOPP_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorHeat_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorHumidity_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorCold_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorWind_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorSleepless_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorNoiseDistance_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorNoiseDb_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorVibrationFrequency_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="StressorVibrationMagnitude_FK" type="xs:unsignedByte" default="0" />
								<xs:element name="PreviousTime" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="PreviousProbability" type="xs:double" default="0" />
								<xs:element name="CalculatedTime" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="CalculatedProbability" type="xs:double" default="0" />
								<xs:element name="SegmentAbortProbability" type="xs:double" default="0" />
								<xs:element name="OrgLevel_FK" type="xs:unsignedByte" default="1" />
								<xs:element name="OrgDSOffOn" type="xs:boolean" default="true" />
								<xs:element name="ContactTeamFlag" type="xs:boolean" default="false" />
								<xs:element name="CrewChiefFlag" type="xs:boolean" default="false" />
								<xs:element name="MOUBF" type="xs:double" default="0" />
								<xs:element name="MTTRDistribution_FK" type="xs:unsignedByte" default="14" />
								<xs:element name="MTTRDataShaping1" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="MTTRDataShaping2" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="MTTRDataShaping3" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="resource">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="ResourceCode_FK" type="xs:unsignedByte" />
								<xs:element name="Name" default="Resource">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="ripair">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Resource_FK" type="xs:int" />
								<xs:element name="Interface_FK" type="xs:int" />
								<xs:element name="ConflictFlag1" type="xs:int" default="0" minOccurs="0" />
								<xs:element name="ConflictFlag2" type="xs:int" default="0" minOccurs="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="ripairconflict">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="RIPair1_FK" type="xs:int" />
								<xs:element name="RIPair2_FK" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="ConflictValue" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="scenario">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="NumberOfShifts" type="xs:int" default="2" />
								<xs:element name="ShiftLength" type="xs:double" default="12" />
								<xs:element name="DateLastModified" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="20" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelToOrg" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelToDS" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelToGS" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelOrgToDS" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelOrgToGS" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelDSToGS" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="TravelCT" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ContactTeamQueueSize" type="xs:int" default="0" />
								<xs:element name="NumberOfContactTeams" type="xs:int" default="0" />
								<xs:element name="ContactTeamCrewSize" type="xs:int" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="scenarioevent">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="TriggerTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="schedule">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="DurationDays" type="xs:short" default="0" />
								<xs:element name="ForceUnit_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="scheduledetail">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Schedule_FK" type="xs:int" />
								<xs:element name="Activity_FK" type="xs:int" />
								<xs:element name="StartTime" type="xs:double" default="0" />
								<xs:element name="EndTime" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="schedulejobmap">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Schedule_FK" type="xs:int" />
								<xs:element name="Job_FK" type="xs:int" />
								<xs:element name="Quantity" type="xs:short" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="segment">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Scenario_FK" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="StartTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="StartDay" type="xs:int" default="1" />
								<xs:element name="Repeat" type="xs:boolean" default="false" />
								<xs:element name="RepeatMean" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="RepeatStdDev" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="CancelTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Duration" default="04:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="UseOperationsMission" type="xs:boolean" default="false" />
								<xs:element name="Mission_FK" type="xs:int" minOccurs="0" />
								<xs:element name="Priority" type="xs:int" default="0" />
								<xs:element name="MaxSystems" type="xs:int" default="1" />
								<xs:element name="MinSystems" type="xs:int" default="1" />
								<xs:element name="DepartureGroups" type="xs:int" default="1" />
								<xs:element name="TimeBetweenDepartures" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="CombatHitProbability" type="xs:double" default="0" />
								<xs:element name="AttritionProbability" type="xs:double" default="0" />
								<xs:element name="ReplacementTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="RepairTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="DistancePerHour" type="xs:double" default="0" />
								<xs:element name="FuelUsage" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="settingsfc">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="ForceUnit_FK" type="xs:int" />
								<xs:element name="RunLength" type="xs:double" default="1" />
								<xs:element name="RunLengthUnits" type="xs:int" default="3" />
								<xs:element name="RandomSeed" type="xs:int" default="1" />
								<xs:element name="DisableReports" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="settingsop">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="NumRuns" type="xs:int" default="1" />
								<xs:element name="RandomSeed" type="xs:int" default="1" />
								<xs:element name="UsePerfectAccuracy" type="xs:boolean" default="false" />
								<xs:element name="UseWorkloadStrategies" type="xs:boolean" default="false" />
								<xs:element name="EnableAnimation" type="xs:boolean" default="false" />
								<xs:element name="UsePTSAdjustments" type="xs:boolean" default="false" />
								<xs:element name="UseCulturalModel" type="xs:boolean" default="false" />
								<xs:element name="CulturalTemplate_FK" type="xs:int" minOccurs="0" />
								<xs:element name="EnablePTSAdjustments" type="xs:boolean" default="false" />
								<xs:element name="IsPersonnelApplied" type="xs:boolean" default="false" />
								<xs:element name="IsTrainingApplied" type="xs:boolean" default="false" />
								<xs:element name="IsStressorsApplied" type="xs:boolean" default="false" />
								<xs:element name="DisableReports" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="settingsmx">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Scenario_FK" type="xs:int" />
								<xs:element name="RunLength" type="xs:double" default="1" />
								<xs:element name="RunLengthUnits" type="xs:int" default="1" />
								<xs:element name="RandomSeed" type="xs:int" default="1" />
								<xs:element name="NumSys" type="xs:int" default="1" />
								<xs:element name="UseCrewLimits" type="xs:boolean" default="false" />
								<xs:element name="UsePTSAdjustments" type="xs:boolean" default="false" />
								<xs:element name="UseAnimation" type="xs:boolean" default="false" />
								<xs:element name="EnablePTSAdjustments" type="xs:boolean" default="false" />
								<xs:element name="IsPersonnelApplied" type="xs:boolean" default="false" />
								<xs:element name="IsTrainingApplied" type="xs:boolean" default="false" />
								<xs:element name="IsStressorsApplied" type="xs:boolean" default="false" />
								<xs:element name="DisableReports" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="snapshot">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" minOccurs="0" />
								<xs:element name="TriggerType" type="xs:int" default="6" />
								<xs:element name="StartTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="RepeatFlag" type="xs:boolean" default="false" />
								<xs:element name="RepeatInterval" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="StopFlag" type="xs:boolean" default="false" />
								<xs:element name="StopTime" default="00:00:00.00">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="13" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="snapshotvariable">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Snapshot_FK" type="xs:int" />
								<xs:element name="Variable_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="sparepart">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Subsystem_FK" type="xs:int" />
								<xs:element name="Scenario_FK" type="xs:int" />
								<xs:element name="Availability" type="xs:double" default="100" />
								<xs:element name="WaitTime" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="specialty">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" type="xs:int" />
								<xs:element name="Name">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="25" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ASVABComposite" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="2" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ASVABCutOffScore" type="xs:short" default="0" />
								<xs:element name="SecondASVABAreaComposite" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="2" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="SecondASVABCutOffScore" type="xs:short" default="0" />
								<xs:element name="LoadedFlag" type="xs:boolean" default="false" />
								<xs:element name="FMStartYear" type="xs:int" default="0" />
								<xs:element name="FMEndYear" type="xs:int" default="0" />
								<xs:element name="FlowedFlag" type="xs:boolean" default="false" />
								<xs:element name="IsOperator" type="xs:boolean" default="false" />
								<xs:element name="IsMaintainer" type="xs:boolean" default="false" />
								<xs:element name="IsSupplySupport" type="xs:boolean" default="false" />
								<xs:element name="IsObsolete" type="xs:boolean" default="false" />
								<xs:element name="Branch" type="xs:unsignedByte" default="4" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="subsystem">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="PartNumber" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="50" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="EquipmentGroup" type="xs:unsignedByte" default="1" />
								<xs:element name="DateLastModified" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="20" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="supply">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="Transporter">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Scenario_FK" type="xs:int" />
								<xs:element name="Subsystem_FK" type="xs:int" minOccurs="0" />
								<xs:element name="Capacity" type="xs:double" default="0" />
								<xs:element name="MaxDailyTrips" type="xs:int" default="1" />
								<xs:element name="LoadTime" type="xs:double" default="0" />
								<xs:element name="Specialty1_FK" type="xs:int" default="352" />
								<xs:element name="Specialty1Grade" type="xs:unsignedByte" default="10" />
								<xs:element name="NumberOfSpecialty1" type="xs:int" default="1" />
								<xs:element name="Specialty2_FK" type="xs:int" minOccurs="0" />
								<xs:element name="Specialty2Grade" type="xs:unsignedByte" default="10" />
								<xs:element name="NumberOfSpecialty2" type="xs:int" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="taskdemand">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="RIPair_FK" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="DemandValue" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="taskinterface">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="Interface_FK" type="xs:int" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="taskoperator">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="NetworkTask_FK" type="xs:int" />
								<xs:element name="Operator_FK" type="xs:int" />
								<xs:element name="IsPrimary" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="timevariant">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:short" />
								<xs:element name="Mean" type="xs:double" default="0" />
								<xs:element name="StdDev" type="xs:double" default="0" />
								<xs:element name="UnplannedActivity_FK" type="xs:int" />
								<xs:element name="Distribution_FK" type="xs:unsignedByte" default="14" />
								<xs:element name="TimeVariantType_FK" type="xs:unsignedByte" default="1" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="trumpmatrix">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Activity_FK_A" type="xs:int" />
								<xs:element name="Activity_FK_B" type="xs:int" />
								<xs:element name="ATrumpsB" type="xs:boolean" default="false" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="unplannedactivity">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Activity_FK" type="xs:int" />
								<xs:element name="InterruptStrategy" type="xs:unsignedByte" default="2" />
								<xs:element name="IsRepeating" type="xs:boolean" default="false" />
								<xs:element name="Stop" type="xs:boolean" default="false" />
								<xs:element name="StartTime" type="xs:double" default="0" />
								<xs:element name="CancelTime" type="xs:double" default="0" />
								<xs:element name="EndTime" type="xs:double" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="usermacro">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Name" default="Macro">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Code" type="xs:string" default="" />
								<xs:element name="ReturnType" type="xs:unsignedByte" default="7" />
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="IsCultural" type="xs:boolean" default="false" />
								<xs:element name="IsArray" type="xs:boolean" default="false" />
								<xs:element name="ArrayDimensions" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="usermacroparameter">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="UserMacro_FK" type="xs:int" />
								<xs:element name="Name" default="Parameter">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Type" type="xs:unsignedByte" default="4" />
								<xs:element name="IsArray" type="xs:boolean" default="false" />
								<xs:element name="ArrayDimensions" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="userstressor">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="userstressorlevel">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="UserStressor_FK" type="xs:int" />
								<xs:element name="Name" default="" minOccurs="0">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="AccuracyDefinition" type="xs:string" default="" minOccurs="0" />
								<xs:element name="TimeDefinition" type="xs:string" default="" minOccurs="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="variable">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Name" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="Type" type="xs:unsignedByte" default="4" />
								<xs:element name="IsCultural" type="xs:boolean" default="false" />
								<xs:element name="Description" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="254" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="InitialValue" type="xs:string" default="0" />
								<xs:element name="IsArray" type="xs:boolean" default="false" />
								<xs:element name="ArrayDimensions" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="ArbitraryType" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="150" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="variablewatch">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Mission_FK" type="xs:int" />
								<xs:element name="Variable_FK" type="xs:int" />
								<xs:element name="ArrayIndex" default="">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="weapon">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Segment_FK" type="xs:int" />
								<xs:element name="Subsystem_FK" type="xs:int" />
								<xs:element name="Rounds" type="xs:int" default="0" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
					<xs:element name="workloadmonitor">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="Id" msdata:AutoIncrement="true" type="xs:int" />
								<xs:element name="Function_FK" type="xs:int" />
								<xs:element name="Operator_FK" type="xs:int" />
								<xs:element name="MSSharpID" type="xs:string" default="" />
								<xs:element name="Name" default="Workload Monitor">
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:maxLength value="100" />
										</xs:restriction>
									</xs:simpleType>
								</xs:element>
								<xs:element name="XPos" type="xs:double" default="-1" />
								<xs:element name="YPos" type="xs:double" default="-1" />
								<xs:element name="Width" type="xs:double" default="65.79296" />
								<xs:element name="Height" type="xs:double" default="19.09114" />
							</xs:sequence>
						</xs:complexType>
					</xs:element>
				</xs:choice>
			</xs:complexType>
			<xs:unique name="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//activity" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="analysispreferences_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//analysispreferences" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="appliedcustomtrainingmx_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//appliedcustomtrainingmx" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="appliedcustomtrainingop_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//appliedcustomtrainingop" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="appliedpersonneltraining_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//appliedpersonneltraining" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="appliedtaxonop_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//appliedtaxonop" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="appliedtaxonmx_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//appliedtaxonmx" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="applieduserstressormx_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//applieduserstressormx" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="applieduserstressorop_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//applieduserstressorop" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="chart_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//chart" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="chartseries_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//chartseries" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="comment_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//comment" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="commentvariable_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//commentvariable" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="component_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//component" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="crewlimit_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//crewlimit" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="culturaltemplate_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//culturaltemplate" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="culturaltemplateparameter_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//culturaltemplateparameter" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="customtraining_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//customtraining" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="customtraininglevel_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//customtraininglevel" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="forceunit_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//forceunit" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="function_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//function" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="goalaction_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//goalaction" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="interface_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//interface" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="job_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//job" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="jobmanningtypemap_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//jobmanningtypemap" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="manning_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//manning" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="mission_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//mission" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="networktask_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//networktask" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="nodelink_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//nodelink" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="operator_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//operator" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="orglevel_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//orglevel" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="path_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//path" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="plugindata_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//plugindata" />
				<xs:field xpath="PluginName" />
			</xs:unique>
			<xs:unique name="repairtask_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//repairtask" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="resource_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//resource" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="ripair_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//ripair" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="ripairconflict_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//ripairconflict" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="scenario_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//scenario" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="scenarioevent_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//scenarioevent" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="schedule_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//schedule" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="scheduledetail_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//scheduledetail" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="schedulejobmap_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//schedulejobmap" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="segment_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//segment" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="settingsfc_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//settingsfc" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="settingsop_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//settingsop" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="settingsmx_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//settingsmx" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="snapshot_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//snapshot" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="snapshotvariable_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//snapshotvariable" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="sparepart_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//sparepart" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="specialty_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//specialty" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="subsystem_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//subsystem" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="supply_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//supply" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="taskdemand_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//taskdemand" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="taskinterface_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//taskinterface" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="taskoperator_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//taskoperator" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="timevariant_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//timevariant" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="trumpmatrix_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//trumpmatrix" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="unplannedactivity_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//unplannedactivity" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="usermacro_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//usermacro" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="usermacroparameter_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//usermacroparameter" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="userstressor_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//userstressor" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="userstressorlevel_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//userstressorlevel" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="variable_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//variable" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="variablewatch_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//variablewatch" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="weapon_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//weapon" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:unique name="workloadmonitor_Constraint1" msdata:ConstraintName="Constraint1" msdata:PrimaryKey="true">
				<xs:selector xpath=".//workloadmonitor" />
				<xs:field xpath="Id" />
			</xs:unique>
			<xs:keyref name="FK_WorkloadMonitor_Operator" refer="operator_Constraint1">
				<xs:selector xpath=".//workloadmonitor" />
				<xs:field xpath="Operator_FK" />
			</xs:keyref>
			<xs:keyref name="FK_WorkloadMonitor_Function" refer="function_Constraint1">
				<xs:selector xpath=".//workloadmonitor" />
				<xs:field xpath="Function_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Weapon_Subsystem" refer="subsystem_Constraint1">
				<xs:selector xpath=".//weapon" />
				<xs:field xpath="Subsystem_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Weapon_Segment" refer="segment_Constraint1">
				<xs:selector xpath=".//weapon" />
				<xs:field xpath="Segment_FK" />
			</xs:keyref>
			<xs:keyref name="FK_VariableWatch_Variable" refer="variable_Constraint1">
				<xs:selector xpath=".//variablewatch" />
				<xs:field xpath="Variable_FK" />
			</xs:keyref>
			<xs:keyref name="FK_VariableWatch_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//variablewatch" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Variable_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//variable" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_UserStressorLevel_UserStressor" refer="userstressor_Constraint1">
				<xs:selector xpath=".//userstressorlevel" />
				<xs:field xpath="UserStressor_FK" />
			</xs:keyref>
			<xs:keyref name="FK_UserMacroParameter_UserMacro" refer="usermacro_Constraint1">
				<xs:selector xpath=".//usermacroparameter" />
				<xs:field xpath="UserMacro_FK" />
			</xs:keyref>
			<xs:keyref name="FK_UserMacro_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//usermacro" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_UnplannedActivitity_Activity" refer="Constraint1">
				<xs:selector xpath=".//unplannedactivity" />
				<xs:field xpath="Activity_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TrumpMatrix_ActivityB" refer="Constraint1">
				<xs:selector xpath=".//trumpmatrix" />
				<xs:field xpath="Activity_FK_B" />
			</xs:keyref>
			<xs:keyref name="FK_TrumpMatrix_ActivityA" refer="Constraint1">
				<xs:selector xpath=".//trumpmatrix" />
				<xs:field xpath="Activity_FK_A" />
			</xs:keyref>
			<xs:keyref name="FK_TimeVariant_UnplannedActivitity" refer="unplannedactivity_Constraint1">
				<xs:selector xpath=".//timevariant" />
				<xs:field xpath="UnplannedActivity_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskOperator_Operator" refer="operator_Constraint1">
				<xs:selector xpath=".//taskoperator" />
				<xs:field xpath="Operator_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskOperator_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//taskoperator" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskOperator_Mission" refer="mission_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//taskoperator" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskInterface_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//taskinterface" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskInterface_Mission" refer="mission_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//taskinterface" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskInterface_Interface" refer="interface_Constraint1">
				<xs:selector xpath=".//taskinterface" />
				<xs:field xpath="Interface_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskDemand_RIPair" refer="ripair_Constraint1">
				<xs:selector xpath=".//taskdemand" />
				<xs:field xpath="RIPair_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskDemand_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//taskdemand" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_TaskDemand_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//taskdemand" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Supply_Subsystem" refer="subsystem_Constraint1">
				<xs:selector xpath=".//supply" />
				<xs:field xpath="Subsystem_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Supply_Specialty_Specialty2" refer="specialty_Constraint1">
				<xs:selector xpath=".//supply" />
				<xs:field xpath="Specialty2_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Supply_Specialty_Specialty1" refer="specialty_Constraint1">
				<xs:selector xpath=".//supply" />
				<xs:field xpath="Specialty1_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Supply_Scenario" refer="scenario_Constraint1">
				<xs:selector xpath=".//supply" />
				<xs:field xpath="Scenario_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SparePart_Subsystem" refer="subsystem_Constraint1">
				<xs:selector xpath=".//sparepart" />
				<xs:field xpath="Subsystem_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SparePart_Scenario" refer="scenario_Constraint1">
				<xs:selector xpath=".//sparepart" />
				<xs:field xpath="Scenario_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SnapshotVariable_Variable" refer="variable_Constraint1">
				<xs:selector xpath=".//snapshotvariable" />
				<xs:field xpath="Variable_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SnapshotVariable_Snapshot" refer="snapshot_Constraint1">
				<xs:selector xpath=".//snapshotvariable" />
				<xs:field xpath="Snapshot_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Snapshot_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//snapshot" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Snapshot_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//snapshot" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SettingsMx_Scenario" refer="scenario_Constraint1">
				<xs:selector xpath=".//settingsmx" />
				<xs:field xpath="Scenario_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SettingsOp_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//settingsop" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SettingsOp_CulturalTemplate" refer="culturaltemplate_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//settingsop" />
				<xs:field xpath="CulturalTemplate_FK" />
			</xs:keyref>
			<xs:keyref name="FK_SettingsFc_ForceUnit" refer="forceunit_Constraint1">
				<xs:selector xpath=".//settingsfc" />
				<xs:field xpath="ForceUnit_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Segment_Scenario" refer="scenario_Constraint1">
				<xs:selector xpath=".//segment" />
				<xs:field xpath="Scenario_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Segment_Mission" refer="mission_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//segment" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ScheduleJobMap_Scedule" refer="schedule_Constraint1">
				<xs:selector xpath=".//schedulejobmap" />
				<xs:field xpath="Schedule_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ScheduleJobMap_Job" refer="job_Constraint1">
				<xs:selector xpath=".//schedulejobmap" />
				<xs:field xpath="Job_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ScheduleDetail_Scedule" refer="schedule_Constraint1">
				<xs:selector xpath=".//scheduledetail" />
				<xs:field xpath="Schedule_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ScheduleDetail_Activity" refer="Constraint1">
				<xs:selector xpath=".//scheduledetail" />
				<xs:field xpath="Activity_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Schedule_ForceUnit" refer="forceunit_Constraint1">
				<xs:selector xpath=".//schedule" />
				<xs:field xpath="ForceUnit_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ScenarioEvent_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//scenarioevent" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ScenarioEvent_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//scenarioevent" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RIPairConflict_RIPair2" refer="ripair_Constraint1">
				<xs:selector xpath=".//ripairconflict" />
				<xs:field xpath="RIPair2_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RIPairConflict_RIPair1" refer="ripair_Constraint1">
				<xs:selector xpath=".//ripairconflict" />
				<xs:field xpath="RIPair1_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RIPairConflict_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//ripairconflict" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RIPair_Resource" refer="resource_Constraint1">
				<xs:selector xpath=".//ripair" />
				<xs:field xpath="Resource_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RIPair_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//ripair" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RIPair_Interface" refer="interface_Constraint1">
				<xs:selector xpath=".//ripair" />
				<xs:field xpath="Interface_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Resource_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//resource" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RepairTask_Specialty_Specialty2" refer="specialty_Constraint1">
				<xs:selector xpath=".//repairtask" />
				<xs:field xpath="Specialty2_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RepairTask_Specialty_Specialty1" refer="specialty_Constraint1">
				<xs:selector xpath=".//repairtask" />
				<xs:field xpath="Specialty1_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RepairTask_OrgLevel" refer="orglevel_Constraint1">
				<xs:selector xpath=".//repairtask" />
				<xs:field xpath="OrgLevel_FK" />
			</xs:keyref>
			<xs:keyref name="FK_RepairTask_Component" refer="component_Constraint1">
				<xs:selector xpath=".//repairtask" />
				<xs:field xpath="Component_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Path_TargetTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//path" />
				<xs:field xpath="TargetTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Path_TargetFunction" refer="function_Constraint1">
				<xs:selector xpath=".//path" />
				<xs:field xpath="TargetFunction_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Path_SourceTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//path" />
				<xs:field xpath="SourceTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Path_SourceFunction" refer="function_Constraint1">
				<xs:selector xpath=".//path" />
				<xs:field xpath="SourceFunction_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Path_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//path" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Operator_Specialty" refer="specialty_Constraint1">
				<xs:selector xpath=".//operator" />
				<xs:field xpath="Specialty_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NodeLink_TargetTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//nodelink" />
				<xs:field xpath="TargetTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NodeLink_TargetFunction" refer="function_Constraint1">
				<xs:selector xpath=".//nodelink" />
				<xs:field xpath="TargetFunction_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NodeLink_SourceFunction" refer="function_Constraint1">
				<xs:selector xpath=".//nodelink" />
				<xs:field xpath="SourceFunction_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NetworkTask_Operator" refer="operator_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//networktask" />
				<xs:field xpath="ChangeOperator_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NetworkTask_Function" refer="function_Constraint1">
				<xs:selector xpath=".//networktask" />
				<xs:field xpath="Function_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NetworkTask_DegradeTask" refer="networktask_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//networktask" />
				<xs:field xpath="DegradeTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NetworkTask_ChangeTask" refer="networktask_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//networktask" />
				<xs:field xpath="ChangeTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_NetworkTask_ChangeOperatorTask" refer="networktask_Constraint1" msdata:DeleteRule="SetNull">
				<xs:selector xpath=".//networktask" />
				<xs:field xpath="ChangeOperatorTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Manning_UnplannedActivitity" refer="unplannedactivity_Constraint1">
				<xs:selector xpath=".//manning" />
				<xs:field xpath="UnplannedActivity_FK" />
			</xs:keyref>
			<xs:keyref name="FK_JobManningTypeMap_Job" refer="job_Constraint1">
				<xs:selector xpath=".//jobmanningtypemap" />
				<xs:field xpath="Job_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Job_Specialty" refer="specialty_Constraint1">
				<xs:selector xpath=".//job" />
				<xs:field xpath="Specialty_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Job_ForceUnit" refer="forceunit_Constraint1">
				<xs:selector xpath=".//job" />
				<xs:field xpath="ForceUnit_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Interface_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//interface" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_GoalAction_Function_OwnerGoal" refer="function_Constraint1">
				<xs:selector xpath=".//goalaction" />
				<xs:field xpath="OwnerGoal_FK" />
			</xs:keyref>
			<xs:keyref name="FK_GoalAction_Function_OtherGoal" refer="function_Constraint1">
				<xs:selector xpath=".//goalaction" />
				<xs:field xpath="OtherGoal_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Function_ParentFunction" refer="function_Constraint1">
				<xs:selector xpath=".//function" />
				<xs:field xpath="ParentFunction_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Function_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//function" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CustomTrainingLevel_CustomTraining" refer="customtraining_Constraint1">
				<xs:selector xpath=".//customtraininglevel" />
				<xs:field xpath="CustomTraining_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CulturalTemplateParameter_Variable" refer="variable_Constraint1">
				<xs:selector xpath=".//culturaltemplateparameter" />
				<xs:field xpath="Variable_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CulturalTemplateParameter_CulturalTemplate" refer="culturaltemplate_Constraint1">
				<xs:selector xpath=".//culturaltemplateparameter" />
				<xs:field xpath="CulturalTemplate_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CulturalTemplate_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//culturaltemplate" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CrewLimit_Specialty" refer="specialty_Constraint1">
				<xs:selector xpath=".//crewlimit" />
				<xs:field xpath="Specialty_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CrewLimit_Scenario" refer="scenario_Constraint1">
				<xs:selector xpath=".//crewlimit" />
				<xs:field xpath="Scenario_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Component_Subsystem" refer="subsystem_Constraint1">
				<xs:selector xpath=".//component" />
				<xs:field xpath="Subsystem_FK" />
			</xs:keyref>
			<xs:keyref name="FK_CommentVariable_Comment" refer="comment_Constraint1">
				<xs:selector xpath=".//commentvariable" />
				<xs:field xpath="Comment_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Comment_Function" refer="function_Constraint1">
				<xs:selector xpath=".//comment" />
				<xs:field xpath="Function_FK" />
			</xs:keyref>
			<xs:keyref name="FK_ChartSeries_Chart" refer="chart_Constraint1">
				<xs:selector xpath=".//chartseries" />
				<xs:field xpath="Chart_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Chart_Mission" refer="mission_Constraint1">
				<xs:selector xpath=".//chart" />
				<xs:field xpath="Mission_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedUserStressorOp_UserStressorLevel" refer="userstressorlevel_Constraint1">
				<xs:selector xpath=".//applieduserstressorop" />
				<xs:field xpath="UserStressorLevel_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedUserStressorOp_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//applieduserstressorop" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedUserStressorMx_UserStressorLevel" refer="userstressorlevel_Constraint1">
				<xs:selector xpath=".//applieduserstressormx" />
				<xs:field xpath="UserStressorLevel_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedUserStressorMx_RepairTask" refer="repairtask_Constraint1">
				<xs:selector xpath=".//applieduserstressormx" />
				<xs:field xpath="RepairTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedTaxonOp_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//appliedtaxonop" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedPersonnelTraining_Specialty" refer="specialty_Constraint1">
				<xs:selector xpath=".//appliedpersonneltraining" />
				<xs:field xpath="Specialty_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedPersonnelTraining_Operator" refer="operator_Constraint1">
				<xs:selector xpath=".//appliedpersonneltraining" />
				<xs:field xpath="Operator_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedCustomTrainingOp_CustomTrainingLevel" refer="customtraininglevel_Constraint1">
				<xs:selector xpath=".//appliedcustomtrainingop" />
				<xs:field xpath="CustomTrainingLevel_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedCustomTrainingOp_NetworkTask" refer="networktask_Constraint1">
				<xs:selector xpath=".//appliedcustomtrainingop" />
				<xs:field xpath="NetworkTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedCustomTrainingMx_CustomTrainingLevel" refer="customtraininglevel_Constraint1">
				<xs:selector xpath=".//appliedcustomtrainingmx" />
				<xs:field xpath="CustomTrainingLevel_FK" />
			</xs:keyref>
			<xs:keyref name="FK_AppliedCustomTrainingMx_RepairTask" refer="repairtask_Constraint1">
				<xs:selector xpath=".//appliedcustomtrainingmx" />
				<xs:field xpath="RepairTask_FK" />
			</xs:keyref>
			<xs:keyref name="FK_Activity_ForceUnit" refer="forceunit_Constraint1">
				<xs:selector xpath=".//activity" />
				<xs:field xpath="ForceUnit_FK" />
			</xs:keyref>
		</xs:element>
	</xs:schema>
	<analysispreferences>
		<Id>0</Id>
		<TimeFormatMission>3</TimeFormatMission>
		<TimeFormatMaint>2</TimeFormatMaint>
		<StressorTempFormat>1</StressorTempFormat>
		<TaskBackgroundColor>Plum</TaskBackgroundColor>
		<TaskBackgroundShape>8</TaskBackgroundShape>
		<TaskSizeType>1</TaskSizeType>
		<FunctionBackgroundColor>LightGray</FunctionBackgroundColor>
		<FunctionBackgroundShape>0</FunctionBackgroundShape>
		<FunctionSizeType>1</FunctionSizeType>
		<GoalBackgroundColor>LightCoral</GoalBackgroundColor>
		<GoalBackgroundShape>5</GoalBackgroundShape>
		<GoalSizeType>1</GoalSizeType>
		<CommentBackgroundColor>LightYellow</CommentBackgroundColor>
		<CommentBackgroundShape>0</CommentBackgroundShape>
		<CommentSizeType>1</CommentSizeType>
		<WorkloadMonitorBackgroundColor>LightGreen</WorkloadMonitorBackgroundColor>
		<WorkloadMonitorBackgroundShape>0</WorkloadMonitorBackgroundShape>
		<WorkloadMonitorSizeType>1</WorkloadMonitorSizeType>
		<ScheduledFunctionBackgroundColor>LightBlue</ScheduledFunctionBackgroundColor>
		<ScheduledFunctionBackgroundShape>0</ScheduledFunctionBackgroundShape>
		<ScheduledFunctionSizeType>1</ScheduledFunctionSizeType>
		<Specialty>0</Specialty>
		<OrgLevel1>Org</OrgLevel1>
		<OrgLevel2>DS</OrgLevel2>
		<OrgLevel3>GS</OrgLevel3>
		<MissionReportsTimeFormat>3</MissionReportsTimeFormat>
		<MaintReportsTimeFormat>3</MaintReportsTimeFormat>
		<ForceTimeFormat>5</ForceTimeFormat>
		<ForceReportsTimeFormat>2</ForceReportsTimeFormat>
		<UseCustomTraining>false</UseCustomTraining>
	</analysispreferences>
	<appliedtaxonop>
		<Id>0</Id>
		<NetworkTask_FK>0</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>1</Id>
		<NetworkTask_FK>0</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>2</Id>
		<NetworkTask_FK>0</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>3</Id>
		<NetworkTask_FK>1</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>4</Id>
		<NetworkTask_FK>1</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>5</Id>
		<NetworkTask_FK>1</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>6</Id>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>7</Id>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>8</Id>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>9</Id>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>10</Id>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>11</Id>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>12</Id>
		<NetworkTask_FK>4</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>13</Id>
		<NetworkTask_FK>4</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>14</Id>
		<NetworkTask_FK>4</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>15</Id>
		<NetworkTask_FK>5</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>16</Id>
		<NetworkTask_FK>5</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>17</Id>
		<NetworkTask_FK>5</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>18</Id>
		<NetworkTask_FK>6</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>19</Id>
		<NetworkTask_FK>6</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>20</Id>
		<NetworkTask_FK>6</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>21</Id>
		<NetworkTask_FK>7</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>22</Id>
		<NetworkTask_FK>7</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>23</Id>
		<NetworkTask_FK>7</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>24</Id>
		<NetworkTask_FK>8</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>25</Id>
		<NetworkTask_FK>8</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>26</Id>
		<NetworkTask_FK>8</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>27</Id>
		<NetworkTask_FK>9</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>28</Id>
		<NetworkTask_FK>9</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>29</Id>
		<NetworkTask_FK>9</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>30</Id>
		<NetworkTask_FK>10</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>31</Id>
		<NetworkTask_FK>10</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>32</Id>
		<NetworkTask_FK>10</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>33</Id>
		<NetworkTask_FK>11</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>34</Id>
		<NetworkTask_FK>11</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>35</Id>
		<NetworkTask_FK>11</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>36</Id>
		<NetworkTask_FK>12</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>37</Id>
		<NetworkTask_FK>12</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>38</Id>
		<NetworkTask_FK>12</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>39</Id>
		<NetworkTask_FK>13</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>40</Id>
		<NetworkTask_FK>13</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>41</Id>
		<NetworkTask_FK>13</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>42</Id>
		<NetworkTask_FK>14</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>43</Id>
		<NetworkTask_FK>14</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>44</Id>
		<NetworkTask_FK>14</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>48</Id>
		<NetworkTask_FK>16</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>49</Id>
		<NetworkTask_FK>16</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>50</Id>
		<NetworkTask_FK>16</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>51</Id>
		<NetworkTask_FK>17</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>52</Id>
		<NetworkTask_FK>17</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>53</Id>
		<NetworkTask_FK>17</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>54</Id>
		<NetworkTask_FK>18</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>55</Id>
		<NetworkTask_FK>18</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>56</Id>
		<NetworkTask_FK>18</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>45</Id>
		<NetworkTask_FK>15</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>46</Id>
		<NetworkTask_FK>15</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>47</Id>
		<NetworkTask_FK>15</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>57</Id>
		<NetworkTask_FK>19</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>58</Id>
		<NetworkTask_FK>19</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>59</Id>
		<NetworkTask_FK>19</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>60</Id>
		<NetworkTask_FK>20</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>61</Id>
		<NetworkTask_FK>20</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>62</Id>
		<NetworkTask_FK>20</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>63</Id>
		<NetworkTask_FK>21</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>64</Id>
		<NetworkTask_FK>21</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>65</Id>
		<NetworkTask_FK>21</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>66</Id>
		<NetworkTask_FK>22</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>67</Id>
		<NetworkTask_FK>22</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>68</Id>
		<NetworkTask_FK>22</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>72</Id>
		<NetworkTask_FK>24</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>73</Id>
		<NetworkTask_FK>24</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>74</Id>
		<NetworkTask_FK>24</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>75</Id>
		<NetworkTask_FK>25</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>76</Id>
		<NetworkTask_FK>25</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>77</Id>
		<NetworkTask_FK>25</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>78</Id>
		<NetworkTask_FK>26</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>79</Id>
		<NetworkTask_FK>26</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>80</Id>
		<NetworkTask_FK>26</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>81</Id>
		<NetworkTask_FK>27</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>82</Id>
		<NetworkTask_FK>27</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>83</Id>
		<NetworkTask_FK>27</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>84</Id>
		<NetworkTask_FK>28</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>85</Id>
		<NetworkTask_FK>28</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>86</Id>
		<NetworkTask_FK>28</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>87</Id>
		<NetworkTask_FK>29</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>88</Id>
		<NetworkTask_FK>29</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonop>
		<Id>89</Id>
		<NetworkTask_FK>29</NetworkTask_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonop>
	<appliedtaxonmx>
		<Id>0</Id>
		<MaintAction_FK>0</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>1</Id>
		<MaintAction_FK>0</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>2</Id>
		<MaintAction_FK>0</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>3</Id>
		<MaintAction_FK>1</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>4</Id>
		<MaintAction_FK>1</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>5</Id>
		<MaintAction_FK>1</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>6</Id>
		<MaintAction_FK>2</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>7</Id>
		<MaintAction_FK>2</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>8</Id>
		<MaintAction_FK>2</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>9</Id>
		<MaintAction_FK>3</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>10</Id>
		<MaintAction_FK>3</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>11</Id>
		<MaintAction_FK>3</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>12</Id>
		<MaintAction_FK>4</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>13</Id>
		<MaintAction_FK>4</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>14</Id>
		<MaintAction_FK>4</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>15</Id>
		<MaintAction_FK>5</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>16</Id>
		<MaintAction_FK>5</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>17</Id>
		<MaintAction_FK>5</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>18</Id>
		<MaintAction_FK>6</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>19</Id>
		<MaintAction_FK>6</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>20</Id>
		<MaintAction_FK>6</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>21</Id>
		<MaintAction_FK>7</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>22</Id>
		<MaintAction_FK>7</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>23</Id>
		<MaintAction_FK>7</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>24</Id>
		<MaintAction_FK>8</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>25</Id>
		<MaintAction_FK>8</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>26</Id>
		<MaintAction_FK>8</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>27</Id>
		<MaintAction_FK>9</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>28</Id>
		<MaintAction_FK>9</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>29</Id>
		<MaintAction_FK>9</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>30</Id>
		<MaintAction_FK>10</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>31</Id>
		<MaintAction_FK>10</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>32</Id>
		<MaintAction_FK>10</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>33</Id>
		<MaintAction_FK>11</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>34</Id>
		<MaintAction_FK>11</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>35</Id>
		<MaintAction_FK>11</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>36</Id>
		<MaintAction_FK>12</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>37</Id>
		<MaintAction_FK>12</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>38</Id>
		<MaintAction_FK>12</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>39</Id>
		<MaintAction_FK>13</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>40</Id>
		<MaintAction_FK>13</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>41</Id>
		<MaintAction_FK>13</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>42</Id>
		<MaintAction_FK>14</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>43</Id>
		<MaintAction_FK>14</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>44</Id>
		<MaintAction_FK>14</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>45</Id>
		<MaintAction_FK>15</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>46</Id>
		<MaintAction_FK>15</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>47</Id>
		<MaintAction_FK>15</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>48</Id>
		<MaintAction_FK>16</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>49</Id>
		<MaintAction_FK>16</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>50</Id>
		<MaintAction_FK>16</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>51</Id>
		<MaintAction_FK>17</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>52</Id>
		<MaintAction_FK>17</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>53</Id>
		<MaintAction_FK>17</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>54</Id>
		<MaintAction_FK>18</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>55</Id>
		<MaintAction_FK>18</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>56</Id>
		<MaintAction_FK>18</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>57</Id>
		<MaintAction_FK>19</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>58</Id>
		<MaintAction_FK>19</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>59</Id>
		<MaintAction_FK>19</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>60</Id>
		<MaintAction_FK>20</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>61</Id>
		<MaintAction_FK>20</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>62</Id>
		<MaintAction_FK>20</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>63</Id>
		<MaintAction_FK>21</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>64</Id>
		<MaintAction_FK>21</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>65</Id>
		<MaintAction_FK>21</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>66</Id>
		<MaintAction_FK>22</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>67</Id>
		<MaintAction_FK>22</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>68</Id>
		<MaintAction_FK>22</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>69</Id>
		<MaintAction_FK>23</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>70</Id>
		<MaintAction_FK>23</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>71</Id>
		<MaintAction_FK>23</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>72</Id>
		<MaintAction_FK>24</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>73</Id>
		<MaintAction_FK>24</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>74</Id>
		<MaintAction_FK>24</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>75</Id>
		<MaintAction_FK>25</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>76</Id>
		<MaintAction_FK>25</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>77</Id>
		<MaintAction_FK>25</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>78</Id>
		<MaintAction_FK>26</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>79</Id>
		<MaintAction_FK>26</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>80</Id>
		<MaintAction_FK>26</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>81</Id>
		<MaintAction_FK>27</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>82</Id>
		<MaintAction_FK>27</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>83</Id>
		<MaintAction_FK>27</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>84</Id>
		<MaintAction_FK>28</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>85</Id>
		<MaintAction_FK>28</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>86</Id>
		<MaintAction_FK>28</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>87</Id>
		<MaintAction_FK>29</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>88</Id>
		<MaintAction_FK>29</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>89</Id>
		<MaintAction_FK>29</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>90</Id>
		<MaintAction_FK>30</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>91</Id>
		<MaintAction_FK>30</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>92</Id>
		<MaintAction_FK>30</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>93</Id>
		<MaintAction_FK>31</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>94</Id>
		<MaintAction_FK>31</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>95</Id>
		<MaintAction_FK>31</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>96</Id>
		<MaintAction_FK>32</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>97</Id>
		<MaintAction_FK>32</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<appliedtaxonmx>
		<Id>98</Id>
		<MaintAction_FK>32</MaintAction_FK>
		<Taxon_FK>0</Taxon_FK>
		<Weight>0</Weight>
	</appliedtaxonmx>
	<comment>
		<Id>0</Id>
		<Function_FK>1</Function_FK>
		<MSSharpID>2</MSSharpID>
		<Name>description of the variable toDeclareCJB, because variable descriptions are limited to 254 character</Name>
		<Notes>toDeclare CJB is a variable which we use to inject code into SimulatorItems. We use the injected code to declare variables of types other than what IMPRINT normally allows.
Variables are declared in SimulatorItems using the Variable Type below and the Variable Name above. They are declared separately from where they are initialized. They are initialized in SimulatorItems.Initialize().

SimulatorItems.Initialize() looks like this:

&lt;code&gt;
public override void Initialize()
{
	Animator = new MAAD....
	...
	ExternalVariables = new ExternalVariables();
	toDeclareCJB = (int)4;
	... // other user variable initializations
	aniActiveStratID = new string[8000];
	... // about 900 lines of stuff that needs to be run
}

// a bunch of stuff
...
public int toDeclareCJB;
... // other user variable declarations
&lt;/code&gt;

So what we do is, provide a crafted initialization field to
1) call a new method which will perform Initialization() after the user variable initializations
2) end Initialization() with a }
3) Declare (and initialize) arbitrary variables of any type // TODO maybe we should initialize within Initialize()?
4) declare the prefix of the new method called in step 1

the intialization looks like this:

4; blah();} CJB.CJBUtility cjb = new CJB.CJBUtility(); public void blah() {

So finally, the new SimulatorItems looks like this:

&lt;code&gt;
public override void Initialize()
{
	Animator = new MAAD....
	...
	ExternalVariables = new ExternalVariables();
	toDeclareCJB = (int)4;
	blah();
}
CJB.CJBUtility cjb = new CJB.CJBUtility();
public void blah() {
	... // other user variable initializations
	aniActiveStratID = new string[8000];
	... // about 900 lines of stuff that needs to be run
}

// a bunch of stuff
...
public int toDeclareCJB;
... // other user variable declarations
&lt;/code&gt;</Notes>
		<XPos>178</XPos>
		<YPos>223</YPos>
		<Width>65.79296</Width>
		<Height>19.09114</Height>
	</comment>
	<comment>
		<Id>1</Id>
		<Function_FK>2</Function_FK>
		<MSSharpID>3</MSSharpID>
		<Name>One workload per task</Name>
		<Notes />
		<XPos>109</XPos>
		<YPos>249</YPos>
		<Width>65.79296</Width>
		<Height>19.09114</Height>
	</comment>
	<commentvariable>
		<Id>1</Id>
		<Variable_FK>2</Variable_FK>
		<Comment_FK>0</Comment_FK>
	</commentvariable>
	<function>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<function>
		<Id>1</Id>
		<Mission_FK>1</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<function>
		<Id>2</Id>
		<Mission_FK>2</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<function>
		<Id>3</Id>
		<Mission_FK>3</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<function>
		<Id>4</Id>
		<Mission_FK>4</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<function>
		<Id>5</Id>
		<Mission_FK>5</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<function>
		<Id>6</Id>
		<Mission_FK>6</Mission_FK>
		<MSSharpID>Root</MSSharpID>
		<Name>Network</Name>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<Scheduled>false</Scheduled>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<Criterion>0</Criterion>
		<WorkloadManagementSuspended>false</WorkloadManagementSuspended>
		<GoalOriented>false</GoalOriented>
		<GoalPriority>0</GoalPriority>
		<GoalInitiatingCondition>return false;</GoalInitiatingCondition>
		<GoalDescription />
		<MissionRunning>1</MissionRunning>
		<Height>0</Height>
		<Width>0</Width>
		<XPos>-1</XPos>
		<YPos>-1</YPos>
	</function>
	<interface>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<interface>
		<Id>1</Id>
		<Mission_FK>1</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<interface>
		<Id>2</Id>
		<Mission_FK>2</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<interface>
		<Id>3</Id>
		<Mission_FK>3</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<interface>
		<Id>4</Id>
		<Mission_FK>4</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<interface>
		<Id>5</Id>
		<Mission_FK>5</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<interface>
		<Id>6</Id>
		<Mission_FK>6</Mission_FK>
		<InterfaceCode_FK>1</InterfaceCode_FK>
		<Name>CrewStation</Name>
	</interface>
	<mission>
		<Id>0</Id>
		<Name>Small MRT Test</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>10/20/2011</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<mission>
		<Id>1</Id>
		<Name>GUI Test Stuff</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>10/20/2011</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<mission>
		<Id>2</Id>
		<Name>Small MRT Test One Workload Per Task</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>10/26/2011</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<mission>
		<Id>3</Id>
		<Name>Scope - Perform All test</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>4/9/2012</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<mission>
		<Id>4</Id>
		<Name>Event Test</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>4/6/2012</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<mission>
		<Id>5</Id>
		<Name>Scope - Ignore new test</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>4/9/2012</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<mission>
		<Id>6</Id>
		<Name>Presentation</Name>
		<Description />
		<SuccessProbability>0</SuccessProbability>
		<AccuracyCriterion>0</AccuracyCriterion>
		<TimeCriterion>0</TimeCriterion>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<DateLastModified>4/10/2012</DateLastModified>
		<Scheduled>false</Scheduled>
	</mission>
	<networktask>
		<Id>0</Id>
		<Function_FK>0</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>// Start task must always be released...
return true;
</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>28</XPos>
		<YPos>79</YPos>
	</networktask>
	<networktask>
		<Id>1</Id>
		<Function_FK>0</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>555</XPos>
		<YPos>134</YPos>
	</networktask>
	<networktask>
		<Id>2</Id>
		<Function_FK>0</Function_FK>
		<Name>Task</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:01.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 1;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>293</XPos>
		<YPos>73</YPos>
	</networktask>
	<networktask>
		<Id>3</Id>
		<Function_FK>0</Function_FK>
		<Name>Task1</Name>
		<Type>1</Type>
		<MSSharpID>2</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 1;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>83.265617370605469</Width>
		<XPos>276</XPos>
		<YPos>139</YPos>
	</networktask>
	<networktask>
		<Id>4</Id>
		<Function_FK>1</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>// Start task must always be released...
return true;
</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>20</XPos>
		<YPos>50</YPos>
	</networktask>
	<networktask>
		<Id>5</Id>
		<Function_FK>1</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>440</XPos>
		<YPos>37</YPos>
	</networktask>
	<networktask>
		<Id>6</Id>
		<Function_FK>1</Function_FK>
		<Name>Task</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect>//ExternalVariables.GUITest.Init();
//ExternalVariables.GUITest.InitMS();
//ExternalVariables.GUITest.Bail();
//ExternalVariables.Utility.p(ExternalVariables.GetType());
//Model.PrintOutput(cjb.GetType());
//toDeclareCJB.Add("blah", "blah");
//cjb.p("whatever");
//CJB.R.GetMember(ExternalVariables, "Utility");
//cjb.p(CJB.R.GetFields(this));
//cjb.p(CJB.R.GetAllFields(this));</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>214</XPos>
		<YPos>78</YPos>
	</networktask>
	<networktask>
		<Id>7</Id>
		<Function_FK>2</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>// Start task must always be released...
return true;
</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>28</XPos>
		<YPos>79</YPos>
	</networktask>
	<networktask>
		<Id>8</Id>
		<Function_FK>2</Function_FK>
		<Name>Task1</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:01.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 1;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>289</XPos>
		<YPos>71</YPos>
	</networktask>
	<networktask>
		<Id>9</Id>
		<Function_FK>2</Function_FK>
		<Name>Task2</Name>
		<Type>1</Type>
		<MSSharpID>2</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 1;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>83.265617370605469</Width>
		<XPos>303</XPos>
		<YPos>130</YPos>
	</networktask>
	<networktask>
		<Id>10</Id>
		<Function_FK>2</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>555</XPos>
		<YPos>134</YPos>
	</networktask>
	<networktask>
		<Id>11</Id>
		<Function_FK>3</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>// Start task must always be released...
return true;
</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>20</XPos>
		<YPos>50</YPos>
	</networktask>
	<networktask>
		<Id>12</Id>
		<Function_FK>3</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>620</XPos>
		<YPos>86</YPos>
	</networktask>
	<networktask>
		<Id>13</Id>
		<Function_FK>3</Function_FK>
		<Name>Task</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect>//SoarIMPRINTPlugin.Scope.SetInput("text", "blurg");
//SoarIMPRINTPlugin.Scope.RunAgent(3);
//string output = SoarIMPRINTPlugin.Scope.GetOutput("response", "text");
//Model.PrintOutput("task 1 output: " + output);</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>200</XPos>
		<YPos>102</YPos>
	</networktask>
	<networktask>
		<Id>14</Id>
		<Function_FK>3</Function_FK>
		<Name>Task1</Name>
		<Type>1</Type>
		<MSSharpID>2</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect>//SoarIMPRINTPlugin.Scope.RunAgent(3);
//string output = SoarIMPRINTPlugin.Scope.GetOutput("response", "text");
//Model.PrintOutput("task 2 output: " + output);</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>83.265617370605469</Width>
		<XPos>339</XPos>
		<YPos>105</YPos>
	</networktask>
	<networktask>
		<Id>16</Id>
		<Function_FK>4</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>// Start task must always be released...
return true;
</ReleaseCond>
		<BeginningEffect>//ExternalVariables.SoarPlugin.RegisterEvents();</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>20</XPos>
		<YPos>50</YPos>
	</networktask>
	<networktask>
		<Id>17</Id>
		<Function_FK>4</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>505</XPos>
		<YPos>87</YPos>
	</networktask>
	<networktask>
		<Id>18</Id>
		<Function_FK>4</Function_FK>
		<Name>Task</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect>//SoarIMPRINTPlugin.Scope scope = new SoarIMPRINTPlugin.Scope();
//Model.PrintOutput("app: " + scope.PluginApplication);
//Model.PrintOutput(this.ExternalVariables.SoarPlugin.getAppCalls());
//Model.PrintOutput(this.ExternalVariables.SoarPlugin.getConstructorCalls());
Model.PrintOutput("1 Task beginning effect");</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>290</XPos>
		<YPos>73</YPos>
	</networktask>
	<networktask>
		<Id>15</Id>
		<Function_FK>3</Function_FK>
		<Name>Task2</Name>
		<Type>1</Type>
		<MSSharpID>3</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>83.265617370605469</Width>
		<XPos>497</XPos>
		<YPos>93</YPos>
	</networktask>
	<networktask>
		<Id>19</Id>
		<Function_FK>5</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>// Start task must always be released...
return true;
</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>121</XPos>
		<YPos>103</YPos>
	</networktask>
	<networktask>
		<Id>20</Id>
		<Function_FK>5</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>693</XPos>
		<YPos>101</YPos>
	</networktask>
	<networktask>
		<Id>21</Id>
		<Function_FK>5</Function_FK>
		<Name>Task</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 3;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect>//Model.PrintOutput(this.GetType());
//Model.FindTask("1").Remove(Entity, ETaskCollection.Task);
//Model.PrintOutput("abort: " + Model.Abort(this.Entity));
/*Model.PrintOutput("suspend: " + Model.Suspend(this.Entity));
Model.PrintOutput("stop: " + Model.Stop(this.Entity));
Model.PrintOutput("abort: " + Model.Abort("Tag", 0));
Model.PrintOutput("suspend: " + Model.Suspend("Tag", 0));
Model.PrintOutput("stop: " + Model.Stop("Tag", 0));
Model.PrintOutput("tag: " + Entity.Tag);*/</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>355</XPos>
		<YPos>50</YPos>
	</networktask>
	<networktask>
		<Id>22</Id>
		<Function_FK>5</Function_FK>
		<Name>Task1</Name>
		<Type>1</Type>
		<MSSharpID>2</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 2;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect>/*Model.PrintOutput("abort: " + Model.Abort(this.Entity));
Model.PrintOutput("suspend: " + Model.Suspend(this.Entity));
Model.PrintOutput("stop: " + Model.Stop(this.Entity));
Model.PrintOutput("abort: " + Model.Abort("ID", "1"));
Model.PrintOutput("suspend: " + Model.Suspend("ID", "1"));
Model.PrintOutput("stop: " + Model.Stop("ID", "1"));
Model.PrintOutput("tag: " + Entity.Tag);*/</BeginningEffect>
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>83.265617370605469</Width>
		<XPos>355</XPos>
		<YPos>168</YPos>
	</networktask>
	<networktask>
		<Id>24</Id>
		<Function_FK>6</Function_FK>
		<Name>Model START</Name>
		<Type>0</Type>
		<MSSharpID>0</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>130.59634399414063</Width>
		<XPos>31</XPos>
		<YPos>98</YPos>
	</networktask>
	<networktask>
		<Id>25</Id>
		<Function_FK>6</Function_FK>
		<Name>Model END</Name>
		<Type>2</Type>
		<MSSharpID>999</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>0</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.0;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>129.87368774414063</Width>
		<XPos>769</XPos>
		<YPos>92</YPos>
	</networktask>
	<networktask>
		<Id>26</Id>
		<Function_FK>6</Function_FK>
		<Name>Scan Roadway</Name>
		<Type>1</Type>
		<MSSharpID>1</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 2;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>274</XPos>
		<YPos>89</YPos>
	</networktask>
	<networktask>
		<Id>27</Id>
		<Function_FK>6</Function_FK>
		<Name>Turn Steering Wheel</Name>
		<Type>1</Type>
		<MSSharpID>2</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.6;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>458</XPos>
		<YPos>81</YPos>
	</networktask>
	<networktask>
		<Id>28</Id>
		<Function_FK>6</Function_FK>
		<Name>Check speed</Name>
		<Type>1</Type>
		<MSSharpID>3</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 2;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>278</XPos>
		<YPos>177</YPos>
	</networktask>
	<networktask>
		<Id>29</Id>
		<Function_FK>6</Function_FK>
		<Name>Press pedal</Name>
		<Type>1</Type>
		<MSSharpID>4</MSSharpID>
		<TimeRequirement>00:00:00.00</TimeRequirement>
		<AccuracyRequirement>0</AccuracyRequirement>
		<AccuracyMeasure_FK>1</AccuracyMeasure_FK>
		<Criterion>0</Criterion>
		<SuccessProbability>100</SuccessProbability>
		<DataShapingInputType>1</DataShapingInputType>
		<Distribution_FK>14</Distribution_FK>
		<DataShaping1>00:00:00.00</DataShaping1>
		<DataShaping2>00:00:00.00</DataShaping2>
		<DataShaping3>00:00:00.00</DataShaping3>
		<DataShapingExpression>return 0.5;</DataShapingExpression>
		<StartTime>00:00:00.00</StartTime>
		<StopTime>00:00:00.00</StopTime>
		<AccuracyMean>0</AccuracyMean>
		<AccuracyStdDev>0</AccuracyStdDev>
		<Priority>3</Priority>
		<InterruptStrategy>2</InterruptStrategy>
		<ReleaseCond>return true;</ReleaseCond>
		<BeginningEffect />
		<EndEffect />
		<ProbDegradeTask>0</ProbDegradeTask>
		<DegradeTime>0</DegradeTime>
		<DegradeAcc>0</DegradeAcc>
		<ProbChangeTask>0</ProbChangeTask>
		<ProbFailMission>0</ProbFailMission>
		<ProbNoEffect>100</ProbNoEffect>
		<ProbChangeOperator>0</ProbChangeOperator>
		<ProbRepeatTask>0</ProbRepeatTask>
		<StressorMOPP_FK>0</StressorMOPP_FK>
		<StressorHeat_FK>0</StressorHeat_FK>
		<StressorHumidity_FK>0</StressorHumidity_FK>
		<StressorCold_FK>0</StressorCold_FK>
		<StressorWind_FK>0</StressorWind_FK>
		<StressorSleepless_FK>0</StressorSleepless_FK>
		<StressorNoiseDistance_FK>0</StressorNoiseDistance_FK>
		<StressorNoiseDb_FK>0</StressorNoiseDb_FK>
		<StressorVibrationFrequency_FK>0</StressorVibrationFrequency_FK>
		<StressorVibrationMagnitude_FK>0</StressorVibrationMagnitude_FK>
		<BranchingDecisionType>0</BranchingDecisionType>
		<PreviousAccuracy>0</PreviousAccuracy>
		<CalculatedAccuracy>0</CalculatedAccuracy>
		<PreviousTime>00:00:00.00</PreviousTime>
		<CalculatedTime>00:00:00.00</CalculatedTime>
		<PreviousProbability>0</PreviousProbability>
		<CalculatedProbability>0</CalculatedProbability>
		<Height>21.091144561767578</Height>
		<Width>75.850250244140625</Width>
		<XPos>480</XPos>
		<YPos>171</YPos>
	</networktask>
	<operator>
		<Id>0</Id>
		<Name>Operator</Name>
		<Specialty_FK>352</Specialty_FK>
		<Automated>false</Automated>
		<IsDefaultOperator>true</IsDefaultOperator>
		<IsCrewMaintainer>false</IsCrewMaintainer>
		<DefaultStrategy>3</DefaultStrategy>
		<TaskShedCriterionD>1</TaskShedCriterionD>
		<TaskShedCriterionE>0</TaskShedCriterionE>
		<Threshold>60</Threshold>
		<PenaltyATime>0</PenaltyATime>
		<PenaltyAAcc>0</PenaltyAAcc>
		<PenaltyETime>0</PenaltyETime>
		<PenaltyEAcc>0</PenaltyEAcc>
	</operator>
	<orglevel>
		<Id>1</Id>
		<Name>Org</Name>
		<Description>Organizational</Description>
	</orglevel>
	<orglevel>
		<Id>2</Id>
		<Name>DS</Name>
		<Description>Direct Support</Description>
	</orglevel>
	<orglevel>
		<Id>3</Id>
		<Name>GS</Name>
		<Description>General Support</Description>
	</orglevel>
	<orglevel>
		<Id>4</Id>
		<Name>DS - Off</Name>
		<Description>Direct Support - off</Description>
	</orglevel>
	<orglevel>
		<Id>5</Id>
		<Name>CT</Name>
		<Description>Contact Team</Description>
	</orglevel>
	<orglevel>
		<Id>6</Id>
		<Name>CC</Name>
		<Description>Crew Chief</Description>
	</orglevel>
	<path>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<SourceTask_FK>0</SourceTask_FK>
		<TargetTask_FK>2</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>1</Id>
		<Mission_FK>0</Mission_FK>
		<SourceTask_FK>2</SourceTask_FK>
		<TargetTask_FK>1</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>2</Id>
		<Mission_FK>0</Mission_FK>
		<SourceTask_FK>0</SourceTask_FK>
		<TargetTask_FK>3</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>3</Id>
		<Mission_FK>0</Mission_FK>
		<SourceTask_FK>3</SourceTask_FK>
		<TargetTask_FK>1</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>4</Id>
		<Mission_FK>1</Mission_FK>
		<SourceTask_FK>4</SourceTask_FK>
		<TargetTask_FK>6</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>5</Id>
		<Mission_FK>1</Mission_FK>
		<SourceTask_FK>6</SourceTask_FK>
		<TargetTask_FK>5</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>6</Id>
		<Mission_FK>2</Mission_FK>
		<SourceTask_FK>7</SourceTask_FK>
		<TargetTask_FK>8</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>8</Id>
		<Mission_FK>2</Mission_FK>
		<SourceTask_FK>8</SourceTask_FK>
		<TargetTask_FK>10</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>string blah = "[";
return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>9</Id>
		<Mission_FK>2</Mission_FK>
		<SourceTask_FK>9</SourceTask_FK>
		<TargetTask_FK>10</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>12</Id>
		<Mission_FK>2</Mission_FK>
		<SourceTask_FK>7</SourceTask_FK>
		<TargetTask_FK>9</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>14</Id>
		<Mission_FK>3</Mission_FK>
		<SourceTask_FK>11</SourceTask_FK>
		<TargetTask_FK>13</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>19</Id>
		<Mission_FK>4</Mission_FK>
		<SourceTask_FK>16</SourceTask_FK>
		<TargetTask_FK>18</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>20</Id>
		<Mission_FK>4</Mission_FK>
		<SourceTask_FK>18</SourceTask_FK>
		<TargetTask_FK>17</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>16</Id>
		<Mission_FK>3</Mission_FK>
		<SourceTask_FK>14</SourceTask_FK>
		<TargetTask_FK>15</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>17</Id>
		<Mission_FK>3</Mission_FK>
		<SourceTask_FK>15</SourceTask_FK>
		<TargetTask_FK>12</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>15</Id>
		<Mission_FK>3</Mission_FK>
		<SourceTask_FK>13</SourceTask_FK>
		<TargetTask_FK>14</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints>457.8503 228.5456,467.8503 228.5456,515 228.5456,515 205,398 205,398 115.5456,329 115.5456,339 115.5456</PathPoints>
	</path>
	<path>
		<Id>23</Id>
		<Mission_FK>5</Mission_FK>
		<SourceTask_FK>19</SourceTask_FK>
		<TargetTask_FK>21</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>24</Id>
		<Mission_FK>5</Mission_FK>
		<SourceTask_FK>19</SourceTask_FK>
		<TargetTask_FK>22</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>25</Id>
		<Mission_FK>5</Mission_FK>
		<SourceTask_FK>21</SourceTask_FK>
		<TargetTask_FK>20</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints>430.8503 60.54557,440.8503 60.54557,500 60.54557,500 111.5456,683 111.5456,693 111.5456</PathPoints>
	</path>
	<path>
		<Id>26</Id>
		<Mission_FK>5</Mission_FK>
		<SourceTask_FK>22</SourceTask_FK>
		<TargetTask_FK>20</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints>438.2656 178.5456,448.2656 178.5456,500 178.5456,500 111.5456,683 111.5456,693 111.5456</PathPoints>
	</path>
	<path>
		<Id>28</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>24</SourceTask_FK>
		<TargetTask_FK>26</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>29</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>26</SourceTask_FK>
		<TargetTask_FK>26</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>30</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>26</SourceTask_FK>
		<TargetTask_FK>27</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>31</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>27</SourceTask_FK>
		<TargetTask_FK>25</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>32</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>24</SourceTask_FK>
		<TargetTask_FK>28</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>33</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>28</SourceTask_FK>
		<TargetTask_FK>28</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>34</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>28</SourceTask_FK>
		<TargetTask_FK>29</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<path>
		<Id>35</Id>
		<Mission_FK>6</Mission_FK>
		<SourceTask_FK>29</SourceTask_FK>
		<TargetTask_FK>25</TargetTask_FK>
		<Probability>0</Probability>
		<TacticalExpr>return true;</TacticalExpr>
		<MultipleExpr>return true;</MultipleExpr>
		<PathPoints />
	</path>
	<resource>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>1</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>2</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>3</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>4</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>5</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>6</Id>
		<Mission_FK>0</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<resource>
		<Id>7</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>8</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>9</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>10</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>11</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>12</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>13</Id>
		<Mission_FK>1</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<resource>
		<Id>14</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>15</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>16</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>17</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>18</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>19</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>20</Id>
		<Mission_FK>2</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<resource>
		<Id>21</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>22</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>23</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>24</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>25</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>26</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>27</Id>
		<Mission_FK>3</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<resource>
		<Id>28</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>29</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>30</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>31</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>32</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>33</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>34</Id>
		<Mission_FK>4</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<resource>
		<Id>35</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>36</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>37</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>38</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>39</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>40</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>41</Id>
		<Mission_FK>5</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<resource>
		<Id>42</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>1</ResourceCode_FK>
		<Name>Visual</Name>
	</resource>
	<resource>
		<Id>43</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>2</ResourceCode_FK>
		<Name>Auditory</Name>
	</resource>
	<resource>
		<Id>44</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>3</ResourceCode_FK>
		<Name>Fine Motor</Name>
	</resource>
	<resource>
		<Id>45</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>4</ResourceCode_FK>
		<Name>Speech</Name>
	</resource>
	<resource>
		<Id>46</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>5</ResourceCode_FK>
		<Name>Cognitive</Name>
	</resource>
	<resource>
		<Id>47</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>6</ResourceCode_FK>
		<Name>Gross Motor</Name>
	</resource>
	<resource>
		<Id>48</Id>
		<Mission_FK>6</Mission_FK>
		<ResourceCode_FK>7</ResourceCode_FK>
		<Name>Tactile</Name>
	</resource>
	<ripair>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<Resource_FK>1</Resource_FK>
		<Interface_FK>0</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>1</Id>
		<Mission_FK>0</Mission_FK>
		<Resource_FK>4</Resource_FK>
		<Interface_FK>0</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>2</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>8</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>3</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>11</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>4</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>9</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>5</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>12</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>6</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>10</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>7</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>13</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>8</Id>
		<Mission_FK>1</Mission_FK>
		<Resource_FK>7</Resource_FK>
		<Interface_FK>1</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>9</Id>
		<Mission_FK>2</Mission_FK>
		<Resource_FK>15</Resource_FK>
		<Interface_FK>2</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>10</Id>
		<Mission_FK>2</Mission_FK>
		<Resource_FK>18</Resource_FK>
		<Interface_FK>2</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>11</Id>
		<Mission_FK>5</Mission_FK>
		<Resource_FK>35</Resource_FK>
		<Interface_FK>5</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripair>
		<Id>12</Id>
		<Mission_FK>6</Mission_FK>
		<Resource_FK>42</Resource_FK>
		<Interface_FK>6</Interface_FK>
		<ConflictFlag1>0</ConflictFlag1>
		<ConflictFlag2>0</ConflictFlag2>
	</ripair>
	<ripairconflict>
		<Id>0</Id>
		<RIPair1_FK>0</RIPair1_FK>
		<RIPair2_FK>0</RIPair2_FK>
		<Mission_FK>0</Mission_FK>
		<ConflictValue>0.4</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>1</Id>
		<RIPair1_FK>0</RIPair1_FK>
		<RIPair2_FK>1</RIPair2_FK>
		<Mission_FK>0</Mission_FK>
		<ConflictValue>0.3</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>2</Id>
		<RIPair1_FK>1</RIPair1_FK>
		<RIPair2_FK>1</RIPair2_FK>
		<Mission_FK>0</Mission_FK>
		<ConflictValue>0.25</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>3</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>2</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.1</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>5</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>3</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.2</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>6</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>4</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.3</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>7</Id>
		<RIPair1_FK>3</RIPair1_FK>
		<RIPair2_FK>3</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.3</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>8</Id>
		<RIPair1_FK>3</RIPair1_FK>
		<RIPair2_FK>4</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.4</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>9</Id>
		<RIPair1_FK>4</RIPair1_FK>
		<RIPair2_FK>4</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.5</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>10</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>5</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.4</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>11</Id>
		<RIPair1_FK>3</RIPair1_FK>
		<RIPair2_FK>5</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.5</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>12</Id>
		<RIPair1_FK>4</RIPair1_FK>
		<RIPair2_FK>5</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.6</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>13</Id>
		<RIPair1_FK>5</RIPair1_FK>
		<RIPair2_FK>5</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.7</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>14</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>6</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.5</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>15</Id>
		<RIPair1_FK>3</RIPair1_FK>
		<RIPair2_FK>6</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.6</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>16</Id>
		<RIPair1_FK>4</RIPair1_FK>
		<RIPair2_FK>6</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.7</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>17</Id>
		<RIPair1_FK>5</RIPair1_FK>
		<RIPair2_FK>6</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.8</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>18</Id>
		<RIPair1_FK>6</RIPair1_FK>
		<RIPair2_FK>6</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.9</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>19</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>7</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.9</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>20</Id>
		<RIPair1_FK>3</RIPair1_FK>
		<RIPair2_FK>7</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>1</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>21</Id>
		<RIPair1_FK>4</RIPair1_FK>
		<RIPair2_FK>7</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.9</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>22</Id>
		<RIPair1_FK>5</RIPair1_FK>
		<RIPair2_FK>7</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.8</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>23</Id>
		<RIPair1_FK>6</RIPair1_FK>
		<RIPair2_FK>7</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.7</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>24</Id>
		<RIPair1_FK>7</RIPair1_FK>
		<RIPair2_FK>7</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.6</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>25</Id>
		<RIPair1_FK>2</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>1</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>26</Id>
		<RIPair1_FK>3</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.9</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>27</Id>
		<RIPair1_FK>4</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.8</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>28</Id>
		<RIPair1_FK>5</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.7</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>29</Id>
		<RIPair1_FK>6</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.6</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>30</Id>
		<RIPair1_FK>7</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.5</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>31</Id>
		<RIPair1_FK>8</RIPair1_FK>
		<RIPair2_FK>8</RIPair2_FK>
		<Mission_FK>1</Mission_FK>
		<ConflictValue>0.4</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>32</Id>
		<RIPair1_FK>9</RIPair1_FK>
		<RIPair2_FK>9</RIPair2_FK>
		<Mission_FK>2</Mission_FK>
		<ConflictValue>0.4</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>33</Id>
		<RIPair1_FK>9</RIPair1_FK>
		<RIPair2_FK>10</RIPair2_FK>
		<Mission_FK>2</Mission_FK>
		<ConflictValue>0.3</ConflictValue>
	</ripairconflict>
	<ripairconflict>
		<Id>34</Id>
		<RIPair1_FK>10</RIPair1_FK>
		<RIPair2_FK>10</RIPair2_FK>
		<Mission_FK>2</Mission_FK>
		<ConflictValue>0.25</ConflictValue>
	</ripairconflict>
	<settingsop>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>true</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<settingsop>
		<Id>1</Id>
		<Mission_FK>1</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>false</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<settingsop>
		<Id>2</Id>
		<Mission_FK>2</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>true</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<settingsop>
		<Id>3</Id>
		<Mission_FK>3</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>false</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<settingsop>
		<Id>4</Id>
		<Mission_FK>4</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>false</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<settingsop>
		<Id>5</Id>
		<Mission_FK>5</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>false</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<settingsop>
		<Id>6</Id>
		<Mission_FK>6</Mission_FK>
		<NumRuns>1</NumRuns>
		<RandomSeed>1</RandomSeed>
		<UsePerfectAccuracy>false</UsePerfectAccuracy>
		<UseWorkloadStrategies>false</UseWorkloadStrategies>
		<EnableAnimation>false</EnableAnimation>
		<UsePTSAdjustments>false</UsePTSAdjustments>
		<UseCulturalModel>false</UseCulturalModel>
		<EnablePTSAdjustments>false</EnablePTSAdjustments>
		<IsPersonnelApplied>false</IsPersonnelApplied>
		<IsTrainingApplied>false</IsTrainingApplied>
		<IsStressorsApplied>false</IsStressorsApplied>
		<DisableReports>false</DisableReports>
	</settingsop>
	<specialty>
		<Id>352</Id>
		<Name>00A</Name>
		<Description>PlaceHolder</Description>
		<ASVABComposite />
		<ASVABCutOffScore>0</ASVABCutOffScore>
		<SecondASVABAreaComposite />
		<SecondASVABCutOffScore>0</SecondASVABCutOffScore>
		<LoadedFlag>false</LoadedFlag>
		<FMStartYear>0</FMStartYear>
		<FMEndYear>0</FMEndYear>
		<FlowedFlag>false</FlowedFlag>
		<IsOperator>true</IsOperator>
		<IsMaintainer>true</IsMaintainer>
		<IsSupplySupport>true</IsSupplySupport>
		<IsObsolete>false</IsObsolete>
		<Branch>4</Branch>
	</specialty>
	<taskdemand>
		<Id>0</Id>
		<RIPair_FK>0</RIPair_FK>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Mission_FK>0</Mission_FK>
		<DemandValue>2</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>1</Id>
		<RIPair_FK>1</RIPair_FK>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Mission_FK>0</Mission_FK>
		<DemandValue>4.6</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>2</Id>
		<RIPair_FK>0</RIPair_FK>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Mission_FK>0</Mission_FK>
		<DemandValue>6</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>3</Id>
		<RIPair_FK>1</RIPair_FK>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Mission_FK>0</Mission_FK>
		<DemandValue>5.3</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>4</Id>
		<RIPair_FK>9</RIPair_FK>
		<NetworkTask_FK>8</NetworkTask_FK>
		<Mission_FK>2</Mission_FK>
		<DemandValue>2</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>7</Id>
		<RIPair_FK>10</RIPair_FK>
		<NetworkTask_FK>9</NetworkTask_FK>
		<Mission_FK>2</Mission_FK>
		<DemandValue>5.3</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>8</Id>
		<RIPair_FK>11</RIPair_FK>
		<NetworkTask_FK>21</NetworkTask_FK>
		<Mission_FK>5</Mission_FK>
		<DemandValue>5</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>9</Id>
		<RIPair_FK>11</RIPair_FK>
		<NetworkTask_FK>22</NetworkTask_FK>
		<Mission_FK>5</Mission_FK>
		<DemandValue>4</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>10</Id>
		<RIPair_FK>12</RIPair_FK>
		<NetworkTask_FK>26</NetworkTask_FK>
		<Mission_FK>6</Mission_FK>
		<DemandValue>2</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>11</Id>
		<RIPair_FK>12</RIPair_FK>
		<NetworkTask_FK>28</NetworkTask_FK>
		<Mission_FK>6</Mission_FK>
		<DemandValue>3</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>12</Id>
		<RIPair_FK>12</RIPair_FK>
		<NetworkTask_FK>27</NetworkTask_FK>
		<Mission_FK>6</Mission_FK>
		<DemandValue>4</DemandValue>
	</taskdemand>
	<taskdemand>
		<Id>13</Id>
		<RIPair_FK>12</RIPair_FK>
		<NetworkTask_FK>29</NetworkTask_FK>
		<Mission_FK>6</Mission_FK>
		<DemandValue>1</DemandValue>
	</taskdemand>
	<taskinterface>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>0</NetworkTask_FK>
		<Interface_FK>0</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>1</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>1</NetworkTask_FK>
		<Interface_FK>0</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>2</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Interface_FK>0</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>3</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Interface_FK>0</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>4</Id>
		<Mission_FK>1</Mission_FK>
		<NetworkTask_FK>4</NetworkTask_FK>
		<Interface_FK>1</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>5</Id>
		<Mission_FK>1</Mission_FK>
		<NetworkTask_FK>5</NetworkTask_FK>
		<Interface_FK>1</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>6</Id>
		<Mission_FK>1</Mission_FK>
		<NetworkTask_FK>6</NetworkTask_FK>
		<Interface_FK>1</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>7</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>7</NetworkTask_FK>
		<Interface_FK>2</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>8</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>8</NetworkTask_FK>
		<Interface_FK>2</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>9</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>9</NetworkTask_FK>
		<Interface_FK>2</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>10</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>10</NetworkTask_FK>
		<Interface_FK>2</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>11</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>11</NetworkTask_FK>
		<Interface_FK>3</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>12</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>12</NetworkTask_FK>
		<Interface_FK>3</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>13</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>13</NetworkTask_FK>
		<Interface_FK>3</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>14</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>14</NetworkTask_FK>
		<Interface_FK>3</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>16</Id>
		<Mission_FK>4</Mission_FK>
		<NetworkTask_FK>16</NetworkTask_FK>
		<Interface_FK>4</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>17</Id>
		<Mission_FK>4</Mission_FK>
		<NetworkTask_FK>17</NetworkTask_FK>
		<Interface_FK>4</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>18</Id>
		<Mission_FK>4</Mission_FK>
		<NetworkTask_FK>18</NetworkTask_FK>
		<Interface_FK>4</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>15</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>15</NetworkTask_FK>
		<Interface_FK>3</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>19</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>19</NetworkTask_FK>
		<Interface_FK>5</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>20</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>20</NetworkTask_FK>
		<Interface_FK>5</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>21</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>21</NetworkTask_FK>
		<Interface_FK>5</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>22</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>22</NetworkTask_FK>
		<Interface_FK>5</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>24</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>24</NetworkTask_FK>
		<Interface_FK>6</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>25</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>25</NetworkTask_FK>
		<Interface_FK>6</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>26</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>26</NetworkTask_FK>
		<Interface_FK>6</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>27</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>27</NetworkTask_FK>
		<Interface_FK>6</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>28</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>28</NetworkTask_FK>
		<Interface_FK>6</Interface_FK>
	</taskinterface>
	<taskinterface>
		<Id>29</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>29</NetworkTask_FK>
		<Interface_FK>6</Interface_FK>
	</taskinterface>
	<taskoperator>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>0</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>1</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>1</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>2</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>2</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>3</Id>
		<Mission_FK>0</Mission_FK>
		<NetworkTask_FK>3</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>4</Id>
		<Mission_FK>1</Mission_FK>
		<NetworkTask_FK>4</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>5</Id>
		<Mission_FK>1</Mission_FK>
		<NetworkTask_FK>5</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>6</Id>
		<Mission_FK>1</Mission_FK>
		<NetworkTask_FK>6</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>7</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>7</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>8</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>8</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>9</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>9</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>10</Id>
		<Mission_FK>2</Mission_FK>
		<NetworkTask_FK>10</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>11</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>11</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>12</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>12</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>13</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>13</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>14</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>14</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>16</Id>
		<Mission_FK>4</Mission_FK>
		<NetworkTask_FK>16</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>17</Id>
		<Mission_FK>4</Mission_FK>
		<NetworkTask_FK>17</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>18</Id>
		<Mission_FK>4</Mission_FK>
		<NetworkTask_FK>18</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>15</Id>
		<Mission_FK>3</Mission_FK>
		<NetworkTask_FK>15</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>19</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>19</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>20</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>20</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>21</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>21</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>22</Id>
		<Mission_FK>5</Mission_FK>
		<NetworkTask_FK>22</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>24</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>24</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>25</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>25</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>26</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>26</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>27</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>27</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>28</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>28</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<taskoperator>
		<Id>29</Id>
		<Mission_FK>6</Mission_FK>
		<NetworkTask_FK>29</NetworkTask_FK>
		<Operator_FK>0</Operator_FK>
		<IsPrimary>true</IsPrimary>
	</taskoperator>
	<variable>
		<Id>0</Id>
		<Mission_FK>0</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>1</Id>
		<Mission_FK>1</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>2</Id>
		<Mission_FK>1</Mission_FK>
		<Name>toDeclareCJB</Name>
		<Type>4</Type>
		<IsCultural>false</IsCultural>
		<Description>see comment in task network for explanation</Description>
		<InitialValue>4; blah();} CJB.CJBUtility cjb = new CJB.CJBUtility(); public void blah() {</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>3</Id>
		<Mission_FK>2</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>4</Id>
		<Mission_FK>3</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>5</Id>
		<Mission_FK>4</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>6</Id>
		<Mission_FK>5</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
	<variable>
		<Id>7</Id>
		<Mission_FK>6</Mission_FK>
		<Name>Clock</Name>
		<Type>3</Type>
		<IsCultural>false</IsCultural>
		<Description />
		<InitialValue>0.0</InitialValue>
		<IsArray>false</IsArray>
		<ArrayDimensions />
		<ArbitraryType />
	</variable>
</IMPRINTProDB>