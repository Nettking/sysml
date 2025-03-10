package StrawberryCultivation {
    doc /* Transitioning from Soil-Based to Hydroponic System using Variations */

    private import ScalarValues::*;
    private import DarTwin1::*;           
    private import DarTwinMetadata::*;

    #dartwin StrawberryCultivation {

        #twinsystem StrawberryController  {

            // Encapsulated variation for cultivation method
            variation CultivationMethod {
                variant before {
                    connect CultivationSystem.FieldMultisensor    to StrawberryDT.multisensor_input;
                    connect CultivationSystem.FieldSoilMoisture   to StrawberryDT.soilMoisture_input;
                    connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
                    connect StrawberryDT.actuator_output_irrigation  to CultivationSystem.FieldActuatorIrrigation;
                    connect StrawberryDT.actuator_output_human       to CultivationSystem.FieldHumanActuator;
                }
                variant afterw {  
                    connect CultivationSystem.FieldMultisensor to StrawberryDT.multisensor_input;
                    connect CultivationSystem.FieldNutrientSensor to StrawberryDT.nutrient_input;
                    connect CultivationSystem.FieldDissolvedOxygen to StrawberryDT.dissolvedOxygen_input;
                    connect CultivationSystem.FieldpHSensor to StrawberryDT.pH_input;
                    connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
                    connect StrawberryDT.actuator_output_pump to CultivationSystem.FieldActuatorPump;
                    connect StrawberryDT.actuator_output_human to CultivationSystem.FieldHumanActuator;
                }
            }

            #digitaltwin StrawberryDT {
                port multisensor_input;
                
                variation DTInputs {
                    variant before {
                        port soilMoisture_input;
                        port actuator_output_irrigation;
                    }
                    variant afterw {  
                        port nutrient_input;
                        port dissolvedOxygen_input;
                        port pH_input;
                        port actuator_output_pump;
                    }
                }

                port actuator_output_ventilation;
                port actuator_output_human;
            }

        } // StrawberryController

        #goal increase_yield {
            attribute yield:Real; // yield in kg per season
            doc /* Maximize strawberry yield under optimal growing conditions */
        }

        #goal apply_decreased_water {
            attribute water:Real; // water usage in liters
            doc /* Adjust water usage based on cultivation method */
            
            variation WaterUsage {
                variant before {
                    doc /* Reduce irrigation amount */
                }
                variant afterw {  
                    doc /* Optimize water recirculation efficiency */
                }
            }
        }

        allocate increase_yield to StrawberryController.StrawberryDT;
        allocate apply_decreased_water to StrawberryController.StrawberryDT;

        part CultivationSystem { // This is the Actual System
            port FieldMultisensor            : Multisensor;
            
            variation CultivationPorts {
                variant before {
                    port FieldSoilMoisture       : SoilMoistureSensor;
                    port FieldActuatorIrrigation : ActuatorIrrigation;
                }
                variant afterw {  
                    port FieldNutrientSensor     : NutrientSensor;
                    port FieldDissolvedOxygen    : DissolvedOxygenSensor;
                    port FieldpHSensor           : pHSensor;
                    port FieldActuatorPump       : ActuatorPump;
                }
            }

            port FieldActuatorVentilation    : ActuatorVentilation;
            port FieldHumanActuator          : HumanActuator;
        }

    } // StrawberryCultivation

    //////////////////////////////////////////////////////////////////////////
    // Domain Part Definitions
    //////////////////////////////////////////////////////////////////////////

    port def Multisensor {
        attribute temperature   : Real;
        attribute humidity      : Real;
        attribute CO2           : Real;
        attribute noise         : Real;
    }

    port def SoilMoistureSensor {
        attribute soilMoisture  : Real;
    }

    port def NutrientSensor {
        attribute nutrientConcentration : Real;
    }

    port def DissolvedOxygenSensor {
        attribute dissolvedOxygen : Real;
    }

    port def pHSensor {
        attribute pH : Real;
    }

    port def ActuatorVentilation {
        attribute ventilation   : Boolean;
    }

    port def ActuatorIrrigation {
        attribute irrigation    : Boolean;
    }

    port def ActuatorPump {
        attribute pump          : Boolean;
    }

    port def HumanActuator {
        attribute human         : Boolean;
    }

}
