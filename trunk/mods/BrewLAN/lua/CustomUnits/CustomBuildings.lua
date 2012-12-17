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
	Cybran =	{'urb4206', 90}, #ED4
	Cybran =	{'srb4401', 10}, #Iron Curtain
    },

    T2ShieldDefense = {
	Cybran =	{'srb4401', 10}, #Iron Curtain
	Cybran =	{'urb4206', 80}, #ED4
	Cybran =	{'urb4205', 60}, #ED3
	UEF =		{'seb4102', 10},
	Aeon =		{'sab4102', 10},
	Seraphim =	{'ssb4102', 10},
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
	UEF =		{'seb5104', 35},
	Cyrban =	{'srb5104', 15},
	Seraphim =	{'ssb5104', 35},
	Aeon =		{'sab5104', 20},
    },

    T1GroundDefense = {
	Aeon =		{'sab2103', 30},
	Cybran =	{'srb2103', 30},
	Seraphim =	{'ssb2103', 30},
	UEF =		{'seb2103', 30},
    },
}