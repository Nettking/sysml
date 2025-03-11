package StrawberryCultivation {
    doc /* based on Indoor Strawberry Cultivation System with Digital Twin, inspired by EnergyComfort3 */
    private import ScalarValues::*;
    private import DarTwin1::*;           
    private import DarTwinMetadata::*;

    #dartwin StrawberryCultivation {

        #twinsystem StrawberryController  {
            connect StrawberryCultivation.CultivationSystem.FieldMultisensor    to StrawberryDT.multisensor_input;
            connect StrawberryDT.actuator_output_ventilation to StrawberryCultivation.CultivationSystem.FieldActuatorVentilation;
            connect StrawberryDT.actuator_output_human       to StrawberryCultivation.CultivationSystem.FieldHumanActuator;

            #digitaltwin StrawberryDT {
                port multisensor_input;
                port actuator_output_ventilation;
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
            port Multisensor;
            port ActuatorVentilation;
            port HumanActuator;
        }

    } // StrawberryCultivation
    
    #dartwin StrawberryCultivation_before :> StrawberryCultivation{
    	#twinsystem :>> StrawberryController  {
            // Updated connections with split sensors and renamed actuators
            connect StrawberryCultivation_before.CultivationSystem.SoilMoistureSensor   to StrawberryDT.soilMoisture_input;
            connect StrawberryDT.actuator_output_irrigation  to StrawberryCultivation_before.CultivationSystem.ActuatorIrrigation;
            
            #digitaltwin :>> StrawberryDT {
                port soilMoisture_input;
                port actuator_output_irrigation;
            }

        } // StrawberryController

      
        part :>> CultivationSystem { 
            port SoilMoistureSensor;
            port ActuatorIrrigation;
        }
    }
    
    #dartwin StrawberryCultivation_afterw :> StrawberryCultivation{
    	#twinsystem :>> StrawberryController  {
            connect StrawberryCultivation_afterw.CultivationSystem.NutrientSensorDevice
            to StrawberryDT.nutrient_input;

        	connect StrawberryCultivation_afterw.CultivationSystem.DissolvedOxygenDevice
            to StrawberryDT.dissolvedOxygen_input;

        	connect StrawberryCultivation_afterw.CultivationSystem.pHSensorDevice
            to StrawberryDT.pH_input;
            
            connect StrawberryDT.actuator_output_pump
            to StrawberryCultivation_afterw.CultivationSystem.ActuatorPumpDevice;
            
            
            #digitaltwin :>> StrawberryDT {
                port nutrient_input: ~NutrientSensorDevice;
        		port dissolvedOxygen_input: ~DissolvedOxygenDevice;
        		port pH_input: ~pHSensorDevice;
        		port actuator_output_pump: ~ActuatorPumpDevice;
            }

        } 
        
        part :>> CultivationSystem { 
        	port NutrientSensorDevice;
        	port DissolvedOxygenDevice;
        	port pHSensorDevice;
        	port ActuatorPumpDevice;
        }
    }
	



}
