package StrawberryCultivation {
    doc /* 
         Transitioning from Soil-Based to Hydroponic System using DarTwin
         */

    private import ScalarValues::*;
    private import DarTwin1::*;
    private import DarTwinMetadata::*;

    // =========================================================
    // (1) BASE MODEL: StrawberryCultivation
    // =========================================================
    #dartwin StrawberryCultivation :> DarTwin {

        // Main twin system
        #twinsystem StrawberryController :> twin_system {

            // Base digital twin (no soil/hydro-specific ports yet)
            #digitaltwin StrawberryDT :> digital_twin {
                port multisensor_input;
                port actuator_output_ventilation;
                port actuator_output_human;

                // Optional base port for nutrient input; used in hydroponics
                port nutrient_input;
            }

            // A connection with two variants (demonstration)
            connection irrigationVariant {
                variant before;
                variant afterw;
            }
        }

        // Example goals
        #goal increase_yield {
            attribute yield:Real;
            doc /* Maximize strawberry yield under optimal conditions */
        }
        #goal apply_decreased_water {
            attribute water:Real;
            doc /* Adjust water usage based on cultivation method */
        }
        allocate increase_yield to StrawberryController.StrawberryDT;
        allocate apply_decreased_water to StrawberryController.StrawberryDT;

        // Physical cultivation system: base device parts
        part CultivationSystem {
            part MultisensorDevice         : MultisensorDevice;
            part ActuatorVentilationDevice : ActuatorVentilationDevice;
            part HumanActuatorDevice       : HumanActuatorDevice;
        }
    } // END StrawberryCultivation

    // ---------------------------------------------------------
    // Define physical device parts with their respective ports.
    // ---------------------------------------------------------
    part def MultisensorDevice {
        port msPort : Multisensor;
    }
    part def ActuatorVentilationDevice {
        port avPort : ActuatorVentilation;
    }
    part def HumanActuatorDevice {
        port haPort : HumanActuator;
    }
    // For soil-based evolution
    part def SoilMoistureDevice {
        port smPort : SoilMoistureSensor;
    }
    part def ActuatorIrrigationDevice {
        port aiPort : ActuatorIrrigation;
    }
    // For hydroponic evolution
    part def NutrientSensorDevice {
        port nsPort : NutrientSensor;
    }
    part def DissolvedOxygenDevice {
        port doPort : DissolvedOxygenSensor;
    }
    part def pHSensorDevice {
        port phPort : pHSensor;
    }
    part def ActuatorPumpDevice {
        port apPort : ActuatorPump;
    }

    // =========================================================
    // (2) EVO_BEFORE: Soil-Based Cultivation
    // =========================================================
    #dartwin Evo_before :> StrawberryCultivation {

        // (A) Specialize the CultivationSystem with soil-based device parts
        part CultivationSystem :>> StrawberryCultivation.CultivationSystem {
            part SoilMoistureDeviceInstance       : SoilMoistureDevice;
            part ActuatorIrrigationDeviceInstance : ActuatorIrrigationDevice;
        }

        // (B) Specialize StrawberryDT with soil-based ports
        #digitaltwin StrawberryDT :>> StrawberryController.StrawberryDT {
            port soilMoisture_input;
            port actuator_output_irrigation;
        }

        // (C) Connect everything in the "twinsystem" block
        #twinsystem {
            // Physical sensor -> DT input
            connect CultivationSystem.MultisensorDevice.msPort 
                to StrawberryDT.multisensor_input;

            // Soil moisture device -> DT soilMoisture_input
            connect CultivationSystem.SoilMoistureDeviceInstance.smPort
                to StrawberryDT.soilMoisture_input;

            // DT outputs -> physical actuators
            connect StrawberryDT.actuator_output_ventilation
                to CultivationSystem.ActuatorVentilationDevice.avPort;

            connect StrawberryDT.actuator_output_irrigation
                to CultivationSystem.ActuatorIrrigationDeviceInstance.aiPort;

            connect StrawberryDT.actuator_output_human
                to CultivationSystem.HumanActuatorDevice.haPort;

            // Reference the 'before' variant
            connection toIrrigation :>> StrawberryCultivation.StrawberryController.irrigationVariant.before;
        }
    } // END Evo_before

    // =========================================================
    // (3) EVO_AFTERW: Hydroponic Cultivation
    // =========================================================
    #dartwin Evo_afterw :> StrawberryCultivation {

        // (A) Specialize the CultivationSystem with hydroponic device parts
        part CultivationSystem :>> StrawberryCultivation.CultivationSystem {
            part NutrientSensorDeviceInstance     : NutrientSensorDevice;
            part DissolvedOxygenDeviceInstance    : DissolvedOxygenDevice;
            part pHSensorDeviceInstance           : pHSensorDevice;
            part ActuatorPumpDeviceInstance       : ActuatorPumpDevice;
        }

        // (B) Specialize StrawberryDT with hydro-based ports
        #digitaltwin StrawberryDT :>> StrawberryController.StrawberryDT {
            // Use :>> to reference the base nutrient_input
            port nutrient_input :>> nutrient_input;
            port dissolvedOxygen_input;
            port pH_input;
            port actuator_output_pump;
        }

        // (C) Connect everything in the "twinsystem" block
        #twinsystem {
            // Physical sensor -> DT input
            connect CultivationSystem.MultisensorDevice.msPort
                to StrawberryDT.multisensor_input;

            // Hydro sensors -> DT inputs
            connect CultivationSystem.NutrientSensorDeviceInstance.nsPort
                to StrawberryDT.nutrient_input;

            connect CultivationSystem.DissolvedOxygenDeviceInstance.doPort
                to StrawberryDT.dissolvedOxygen_input;

            connect CultivationSystem.pHSensorDeviceInstance.phPort
                to StrawberryDT.pH_input;

            // DT outputs -> physical actuators
            connect StrawberryDT.actuator_output_ventilation
                to CultivationSystem.ActuatorVentilationDevice.avPort;

            connect StrawberryDT.actuator_output_pump
                to CultivationSystem.ActuatorPumpDeviceInstance.apPort;

            connect StrawberryDT.actuator_output_human
                to CultivationSystem.HumanActuatorDevice.haPort;

            // Reference the 'afterw' variant
            connection toIrrigation :>> StrawberryCultivation.StrawberryController.irrigationVariant.afterw;
        }
    } // END Evo_afterw

    // =========================================================
    // (4) DOMAIN PORT DEFINITIONS
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
