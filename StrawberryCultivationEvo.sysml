package StrawberryCultivation {
    doc /* 
       Demonstration of DarTwin inheritance for an evolution
       from soil-based to hydroponic strawberry cultivation.
       "Before" and "After" are clearly separated in a single model.
    */

    //////////////////////////////////////////////////////////////////////////
    // Domain Part and Port Definitions (Common to Both Variations)
    //////////////////////////////////////////////////////////////////////////

    port def Multisensor {
        attribute temperature : Real;
        attribute humidity    : Real;
        attribute CO2         : Real;
        attribute noise       : Real;
    }

    port def SoilMoistureSensor {
        attribute soilMoisture : Real;
    }

    port def HydroponicSensor {
        attribute nutrientConcentration : Real;
        attribute dissolvedOxygen       : Real;
        attribute pH                    : Real;
    }

    port def ActuatorVentilation {
        attribute ventilation : Boolean;
    }

    port def ActuatorIrrigation {
        attribute irrigation  : Boolean;
    }

    port def HumanActuator {
        attribute human       : Boolean;
    }

    port def PumpMonitor {
        attribute pumpStatus : Boolean;
        attribute anomaly    : Boolean;
    }

    part def Communication {
        port dataInput;
        port networkOutput;
        attribute MQTT         : Boolean;
        attribute cloudStorage : Boolean;
        attribute localNetwork : Boolean;
    }

    //////////////////////////////////////////////////////////////////////////
    // The Evolution Definition Using DarTwin Inheritance
    //////////////////////////////////////////////////////////////////////////

    // This DarTwin defines how the system evolves:
    // - #before (SoilBased) describes the soil moisture sensor, irrigation actuator, and water-saving goal
    // - #after (Hydroponic) describes the hydroponic sensor, pump monitor, and hydroponic optimization goal
    DarTwin StrawberryTransition {
        #role "StrawberryController"
        #role "CultivationSystem"

        // ------------------ BEFORE Variation: Soil-Based ------------------
        #before SoilBased {
            // Soil moisture sensor & connection
            connection connect CultivationSystem.FieldSoilMoisture to StrawberryDT.soilMoisture_input;
            part FieldSoilMoisture : SoilMoistureSensor;

            // Irrigation actuator
            part FieldActuatorIrrigation : ActuatorIrrigation;

            // Goal to decrease water usage
            goal apply_decreased_water {
                attribute water : Real;
                doc /* Apply a moderately decreased amount of water usage (soil-based cultivation). */
            }
        }

        // ------------------ AFTER Variation: Hydroponic -------------------
        #after Hydroponic {
            // Hydroponic sensor & connection
            connection connect CultivationSystem.FieldHydroponicSensor to StrawberryDT.hydroponicSensor_input;
            part FieldHydroponicSensor : HydroponicSensor;

            // Pump monitor replaces irrigation
            part FieldPumpMonitor : PumpMonitor;
            connection connect StrawberryDT.pump_monitor_output to CultivationSystem.FieldPumpMonitor;

            // Goal to optimize hydroponic conditions
            goal optimize_hydroponic_conditions {
                attribute nutrientConcentration : Real;
                attribute dissolvedOxygen       : Real;
                attribute pH                    : Real;
                doc /* Optimize nutrient solution parameters for hydroponic cultivation. */
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Main System Definition That Inherits the Evolution
    //////////////////////////////////////////////////////////////////////////

    #dartwin StrawberryCultivation inherits StrawberryTransition {

        #twinsystem StrawberryController {
            // Common connections (valid in both before/after):
            connect CultivationSystem.FieldMultisensor       to StrawberryDT.multisensor_input;
            connect StrawberryDT.actuator_output_ventilation to CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_human       to CultivationSystem.FieldHumanActuator;

            #digitaltwin StrawberryDT {
                // Shared ports for environmental sensing, ventilation, human
                port multisensor_input;
                port actuator_output_ventilation;
                port actuator_output_human;

                // Variation ports (soil vs hydroponic)
                port soilMoisture_input;
                port hydroponicSensor_input;
                port pump_monitor_output;
            }
        }

        part CultivationSystem {
            // Always present: Environmental sensor, ventilation, human actuator
            port FieldMultisensor         : Multisensor;
            port FieldActuatorVentilation : ActuatorVentilation;
            port FieldHumanActuator       : HumanActuator;

            // Variation placeholders:
            //  - #before => FieldSoilMoisture, FieldActuatorIrrigation
            //  - #after  => FieldHydroponicSensor, FieldPumpMonitor

            part Comms : Communication;
        }
    } // #dartwin StrawberryCultivation

} // package StrawberryCultivation
