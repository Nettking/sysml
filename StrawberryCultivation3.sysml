package StrawberryCultivation {
    doc /* based on Indoor Strawberry Cultivation System with Digital Twin, inspired by EnergyComfort3 */
    private import ScalarValues::*;
    private import DarTwin1::*;           
    private import DarTwinMetadata::*;

    #dartwin StrawberryCultivation {

        #twinsystem StrawberryController  {
            // Updated connections with split sensors and renamed actuators
            connect StrawberryCultivation.CultivationSystem.FieldMultisensor    to StrawberryDT.multisensor_input;
            connect StrawberryCultivation.CultivationSystem.FieldSoilMoisture   to StrawberryDT.soilMoisture_input;
            connect StrawberryDT.actuator_output_ventilation to StrawberryCultivation.CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_irrigation  to StrawberryCultivation.CultivationSystem.FieldActuatorIrrigation;
            connect StrawberryDT.actuator_output_human       to StrawberryCultivation.CultivationSystem.FieldHumanActuator;

            #digitaltwin StrawberryDT {
                port multisensor_input;
                port soilMoisture_input;
                port actuator_output_ventilation;
                port actuator_output_irrigation;
                port actuator_output_human;
            }

        } // StrawberryController

        #goal increase_yield {
            attribute yield:Real; // yield in kg per season
            doc /* maximize strawberry yield under optimal growing conditions */
        }

        #goal apply_decreased_water {
            attribute water:Real; // water usage in liters
            doc /* apply a moderately decreased amount of water usage */
        }
        allocate increase_yield to StrawberryController.StrawberryDT;
        allocate apply_decreased_water to StrawberryController.StrawberryDT;

        part CultivationSystem { // This is the Actual System
            port FieldMultisensor            : Multisensor;
            port FieldSoilMoisture           : SoilMoistureSensor;
            port FieldActuatorVentilation    : ActuatorVentilation;
            port FieldActuatorIrrigation     : ActuatorIrrigation;
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

    port def ActuatorVentilation {
        attribute ventilation   : Boolean;
    }

    port def ActuatorIrrigation {
        attribute irrigation    : Boolean;
    }

    port def HumanActuator {
        attribute human         : Boolean;
    }



}
