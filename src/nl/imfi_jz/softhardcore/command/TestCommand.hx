package nl.imfi_jz.softhardcore.command;

import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class TestCommand implements Command {
    public function new() {
        
    }

	public function getName():String {
		return "test";
	}

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {}

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
        executor.heal(Std.parseFloat(arguments[0]));
        executor.tell("oof lol");
    }

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {}

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {}
}