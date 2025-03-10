package StrawberryCultivation {
    doc /* Transitioning from Soil-Based to Hydroponic System using DarTwin */

    private import ScalarValues::*;
    private import DarTwin1::*;           
    private import DarTwinMetadata::*;

    // Base DarTwin model
    #dartwin StrawberryCultivation :> DarTwin {
        
        #twinsystem StrawberryController :> twin_system {
            
            #digitaltwin StrawberryDT :> digital_twin {
                port multisensor_input;
                port actuator_output_ventilation;
                port actuator_output_human;
            }
        }
        
        #goal increase_yield {
            attribute yield:Real; 
            doc /* Maximize strawberry yield under optimal conditions */
        }

        #goal apply_decreased_water {
            attribute water:Real; 
            doc /* Adjust water use based on cultivation method */
        }

        allocate increase_yield to StrawberryController.StrawberryDT;
        allocate apply_decreased_water to StrawberryController.StrawberryDT;

        // Cultivation System (Physical setup for sensors and actuators)
        part CultivationSystem {
            port FieldMultisensor            : Multisensor;
            port FieldActuatorVentilation    : ActuatorVentilation;
            port FieldHumanActuator          : HumanActuator;
        }

    } // StrawberryCultivation

    // Evolution: Soil-based cultivation (before transformation)
    #dartwin Evo_before :> StrawberryCultivation {
        
        #twinsystem {
            connect CultivationSystem.FieldMultisensor to StrawberryDT.multisensor_input;
            connect CultivationSystem.FieldSoilMoisture to StrawberryDT.soilMoisture_input;
            connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_irrigation to CultivationSystem.FieldActuatorIrrigation;
            connect StrawberryDT.actuator_output_human to CultivationSystem.FieldHumanActuator;
        }

        #digitaltwin StrawberryDT {
            port soilMoisture_input;
            port actuator_output_irrigation;
        }

        // Add soil-specific ports back to the physical system
        part CultivationSystem {
            port FieldSoilMoisture           : SoilMoistureSensor;
            port FieldActuatorIrrigation     : ActuatorIrrigation;
        }

    }

    // Evolution: Hydroponic cultivation (after transformation)
    #dartwin Evo_afterw :> StrawberryCultivation {
        
        #twinsystem {
            connect CultivationSystem.FieldMultisensor to StrawberryDT.multisensor_input;
            connect CultivationSystem.FieldNutrientSensor to StrawberryDT.nutrient_input;
            connect CultivationSystem.FieldDissolvedOxygen to StrawberryDT.dissolvedOxygen_input;
            connect CultivationSystem.FieldpHSensor to StrawberryDT.pH_input;
            connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_pump to CultivationSystem.FieldActuatorPump;
            connect StrawberryDT.actuator_output_human to CultivationSystem.FieldHumanActuator;
        }

        #digitaltwin StrawberryDT {
            port nutrient_input;
            port dissolvedOxygen_input;
            port pH_input;
            port actuator_output_pump;
        }

        // Add hydroponic-specific ports to the physical system
        part CultivationSystem {
            port FieldNutrientSensor         : NutrientSensor;
            port FieldDissolvedOxygen        : DissolvedOxygenSensor;
            port FieldpHSensor               : pHSensor;
            port FieldActuatorPump           : ActuatorPump;
        }

    }

    //////////////////////////////////////////////////////////////////////////
    // Port definitions for physical system
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
