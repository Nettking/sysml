package StrawberryCultivation {
    doc /* Transitioning from Soil-Based to Hydroponic System using DarTwin */

    private import ScalarValues::*;
    private import DarTwin1::*;           
    private import DarTwinMetadata::*;

    // =========================================================
    // 1) BASE MODEL: StrawberryCultivation
    // =========================================================
    #dartwin StrawberryCultivation :> DarTwin {
        
        // The main twin system
        #twinsystem StrawberryController :> twin_system {
            
            // The base digital twin (no soil/hydro-specific ports yet)
            #digitaltwin StrawberryDT :> digital_twin {
                port multisensor_input;
                port actuator_output_ventilation;
                port actuator_output_human;
            }
        }
        
        // Example goals (requirements)
        #goal increase_yield {
            attribute yield:Real; 
            doc /* Maximize strawberry yield under optimal conditions */
        }

        #goal apply_decreased_water {
            attribute water:Real; 
            doc /* Adjust water usage based on cultivation method */
        }

        // Allocate goals to the digital twin
        allocate increase_yield to StrawberryController.StrawberryDT;
        allocate apply_decreased_water to StrawberryController.StrawberryDT;

        // The physical cultivation system (base ports only)
        part CultivationSystem {
            port FieldMultisensor         : Multisensor;
            port FieldActuatorVentilation : ActuatorVentilation;
            port FieldHumanActuator       : HumanActuator;
        }

    } // END StrawberryCultivation


    // =========================================================
    // 2) EVO_BEFORE: Soil-Based Cultivation
    // =========================================================
    #dartwin Evo_before :> StrawberryCultivation {
        
        // (A) SPECIALIZE the base CultivationSystem to add soil-specific ports
        part CultivationSystem :> StrawberryCultivation.CultivationSystem {
            port FieldSoilMoisture       : SoilMoistureSensor;
            port FieldActuatorIrrigation : ActuatorIrrigation;
        }

        // (B) SPECIALIZE the base StrawberryDT to add soil-based ports
        #digitaltwin StrawberryDT :> StrawberryController.StrawberryDT {
            port soilMoisture_input;
            port actuator_output_irrigation;
        }

        // (C) Connect everything in the "twinsystem" block
        #twinsystem {
            // Physical sensor -> Digital Twin input
            connect CultivationSystem.FieldMultisensor to StrawberryDT.multisensor_input;
            connect CultivationSystem.FieldSoilMoisture to StrawberryDT.soilMoisture_input;
            
            // Digital Twin outputs -> Physical actuators
            connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_irrigation to CultivationSystem.FieldActuatorIrrigation;
            connect StrawberryDT.actuator_output_human to CultivationSystem.FieldHumanActuator;
        }
    } // END Evo_before


    // =========================================================
    // 3) EVO_AFTERW: Hydroponic Cultivation
    // =========================================================
    #dartwin Evo_afterw :> StrawberryCultivation {

        // (A) SPECIALIZE the base CultivationSystem to add hydro-specific ports
        part CultivationSystem :> StrawberryCultivation.CultivationSystem {
            port FieldNutrientSensor     : NutrientSensor;
            port FieldDissolvedOxygen    : DissolvedOxygenSensor;
            port FieldpHSensor           : pHSensor;
            port FieldActuatorPump       : ActuatorPump;
        }

        // (B) SPECIALIZE the base StrawberryDT to add hydro-based ports
        #digitaltwin StrawberryDT :> StrawberryController.StrawberryDT {
            port nutrient_input;
            port dissolvedOxygen_input;
            port pH_input;
            port actuator_output_pump;
        }

        // (C) Connect everything in the "twinsystem" block
        #twinsystem {
            // Physical sensor -> Digital Twin input
            connect CultivationSystem.FieldMultisensor to StrawberryDT.multisensor_input;
            connect CultivationSystem.FieldNutrientSensor to StrawberryDT.nutrient_input;
            connect CultivationSystem.FieldDissolvedOxygen to StrawberryDT.dissolvedOxygen_input;
            connect CultivationSystem.FieldpHSensor to StrawberryDT.pH_input;

            // Digital Twin outputs -> Physical actuators
            connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_pump to CultivationSystem.FieldActuatorPump;
            connect StrawberryDT.actuator_output_human to CultivationSystem.FieldHumanActuator;
        }
    } // END Evo_afterw


    // =========================================================
    // 4) DOMAIN PORT DEFINITIONS
    // =========================================================

    port def Multisensor {
        attribute temperature : Real;
        attribute humidity    : Real;
        attribute CO2         : Real;
        attribute noise       : Real;
    }

    port def SoilMoistureSensor {
        attribute soilMoisture : Real;
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
        attribute ventilation : Boolean;
    }

    port def ActuatorIrrigation {
        attribute irrigation : Boolean;
    }

    port def ActuatorPump {
        attribute pump : Boolean;
    }

    port def HumanActuator {
        attribute human : Boolean;
    }

} // END package
