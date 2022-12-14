package nl.imfi_jz.softhardcore.command;

import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.World;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class SetMaxHealthCommand implements Command {
    private final worlds:Array<World>;

    public function new(worlds) {
        this.worlds = worlds;
    }

	public function getName():String {
		return "setmaxhealth";
	}

    private function execute(?executor:MessageReceiver, playerName:String, health:String) {
        for(world in worlds){
            for(player in world.getPlayers()){
                if(player.getName() == playerName){
                    try {
                        player.getCondition().setMax(Std.parseInt(health));
                        executor.tell('Your max health has been set to $health');
                    }
                    catch(ex) {
                        if(executor == null){
                            throw ex;
                        }
                        else {
                            executor.tell('Found player $playerName but could not set health to $health');
                            tellUsage(executor);
                        }
                    }
                    return;
                }
            }
        }

        if(executor != null){
            executor.tell('Could not find online player with name $playerName');
        }
    }

    private inline function tellUsage(executor:MessageReceiver) {
        executor.tell('Usage: ' + getName() + ' <playername> <health (whole number)>');
    }

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
        try {
            execute(executor, arguments[0], arguments[1]);
        }
        catch(ex) {
            tellUsage(executor);
        }
    }

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
        try {
            execute(executor, arguments[0], arguments[1]);
        }
        catch(ex) {
            tellUsage(executor);
        }
    }

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {
        execute(null, arguments[0], arguments[1]);
    }

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {
        execute(null, arguments[0], arguments[1]);
    }
}