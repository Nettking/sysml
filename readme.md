# Strawberry Cultivation Digital Twin Model

This repository contains a SysML v2 model for a digital twin of a strawberry cultivation system. The model leverages two libraries to structure the digital twin and its metadata, and it implements two evolution variants to address different cultivation approaches.

## Overview

The **StrawberryCultivation Package** implements a digital twin model for strawberry cultivation by importing the following libraries:

The package defines:

- **A Base Model:**  
  Represents the core cultivation system.

- **Two Evolution Variants:**
  - **Evo_before:** Specializes the base model for a soil-based cultivation approach by adding soil-specific ports and relationships.
  - **Evo_afterw:** Specializes the base model for a hydroponic system by introducing ports for nutrient sensing, dissolved oxygen, pH monitoring, and pump actuation.

## File Structure 
- `StrawberryCultivation.sysml`  
  The base model for the strawberry cultivation system (without evolution).

- `StrawberryCultivationEvo.sysml`  
  Implements evolution variants:
  - **Evo_before:** Soil-based specialization.
  - **Evo_afterw:** Hydroponic specialization.

- `StrawberryCultivationEvo2.sysml`  
  A refined evolution variant that details physical device parts and specific variant connections for both soil-based and hydroponic approaches.



## Getting Started

### Prerequisites

- A SysML v2-compliant modeling tool or editor that supports the textual syntax used in these files.
- Basic understanding of SysML concepts, particularly those related to digital twins and system modeling.

