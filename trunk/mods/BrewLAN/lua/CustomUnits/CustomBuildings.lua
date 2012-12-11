#****************************************************************************
#**
#**	File:		/lua/CustomUnits/CustomUnits.lua
#**
#**	Description:	Buildings for Sorian AI
#**
#**	Copyright © 2009 BrewLAN
#**
#****************************************************************************

UnitList = {

	##Shields		*********************************************

    T3ShieldDefense = {
	Cybran =	{'urb4206', 100}, #ED4
    },

    T2ShieldDefense = {
	Cybran =	{'brb4401', 30}, #Iron Curtain
	Cybran =	{'urb4206', 80}, #ED4
	Cybran =	{'urb4205', 60}, #ED3
	UEF =		{'beb4102', 10},
	Aeon =		{'bab4102', 10},
	Seraphim =	{'bsb4102', 10},
    },

	##Tech 3 Buildings	*********************************************

    T3AADefense = {
	Cybran =	{'srb2306', 33},
	Seraphim =	{'ssb2306', 33},
	Aeon =		{'sab2306', 33},
    },

    T2GroundDefense = {
	Cybran =	{'srb2306', 33},
	Seraphim =	{'ssb2306', 33},
	Aeon =		{'sab2306', 33},
    },

	##Tech 2 Buildings	*********************************************

    MassStorage = {
	UEF =		{'seb1206', 15},
	Cybran =	{'srb1206', 15},
	Aeon =		{'sab1206', 15},
	Seraphim =	{'ssb1206', 15},
    },

    EnergyStorage = {
	UEF =		{'seb1205', 15},
	Cybran =	{'srb1205', 15},
	Aeon =		{'sab1205', 15},
	Seraphim =	{'ssb1205', 15},
    },

	##Tech 1 Buildings	*********************************************

    T2AirStagingPlatform = {
	UEF =		{'beb5104', 15},
	Cyrban =	{'brb5104', 15},
	Seraphim =	{'ssb5104', 35},
	Aeon =		{'bab5104', 20},
    },

    T1GroundDefense = {
	Aeon =		{'bab2103', 30},
	Cybran =	{'brb2103', 30},
	Seraphim =	{'bsb2103', 30},
	UEF =		{'beb2103', 30},
    },
}