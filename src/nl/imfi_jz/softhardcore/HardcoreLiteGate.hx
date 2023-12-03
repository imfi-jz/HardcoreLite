package nl.imfi_jz.softhardcore;

import nl.imfi_jz.softhardcore.event.PlayerInteractEvent;
import nl.imfi_jz.softhardcore.command.SetHealthReductionCommand;
import nl.imfi_jz.softhardcore.command.SetMaxHealthCommand;
import nl.imfi_jz.softhardcore.event.PlayerRespawnEvent;
import nl.imfi_jz.softhardcore.event.PlayerDeathEvent;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate;
import nl.imfi_jz.softhardcore.file.Config;

@:keep
class HardcoreLiteGate implements Gate {

	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());

        final config = new Config(plugin.getFileSystemManager().getIniFile(
            "config",
            null,
            plugin.getName() + ' configuration.'
        ));

        plugin.getRegisterer().registerEvent(
            new PlayerDeathEvent(config)
        );
        plugin.getRegisterer().registerEvent(
            new PlayerRespawnEvent(config, plugin.getGame().getDisplayableMessageBuilder(), plugin.getScheduler())
        );
        plugin.getRegisterer().registerEvent(
            new PlayerInteractEvent(config, plugin.getGame().getDisplayableMessageBuilder())
        );

        plugin.getRegisterer().registerCommand(
            new SetMaxHealthCommand(plugin.getGame().getWorlds())
        );
        plugin.getRegisterer().registerCommand(
            new SetHealthReductionCommand(config)
        );

        Debugger.log("Health reduction on death: " + config.getHealthReductionOnDeath());
    }

	public function disable(plugin:Plugin) {

    }
}