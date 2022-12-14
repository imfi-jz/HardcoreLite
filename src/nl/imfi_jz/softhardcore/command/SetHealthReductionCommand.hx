package nl.imfi_jz.softhardcore.command;

import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;
import nl.imfi_jz.softhardcore.file.Config;

class SetHealthReductionCommand implements Command {
	private final config:Config;

    public function new(config) {
		this.config = config;
	}

	public function getName():String {
		return "setheartreduction";
	}

	public function execute(?executor:MessageReceiver, heartCount:String) {
		final heartCountFloat = Std.parseFloat(heartCount);
		if(heartCountFloat < 0){
			if(executor != null){
				executor.tell("Heart count should be a positive number");
				executor.tell("Usage: " + getName() + " <heartcount>");
			}
		}
		else {
			config.setHealthReductionOnDeath(heartCountFloat);
			if(executor != null){
				executor.tell("Set heart reduction on death to " + heartCountFloat);
			}
		}
	}

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
		execute(executor, arguments[0]);
	}

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
		if(executor.getPermissionLevel() >= 4){
			execute(executor, arguments[0]);
		}
		else {
			executor.tell("You do not have permission to use this command");
		}
	}

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {
		execute(null, arguments[0]);
	}

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {
		execute(null, arguments[0]);
	}
}