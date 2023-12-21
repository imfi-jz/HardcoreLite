package nl.imfi_jz.softhardcore;

import nl.imfi_jz.minecraft_api.implementation.Recipe.ConstructableShapedRecipe;
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
        #if !mc_debug
            plugin.getConsoleLogger().setSeverityLevelMute(nl.imfi_jz.minecraft_api.MessageReceiver.SeverityGuideline.Log, true);
        #end

        final config = new Config(plugin.getFileSystemManager().getYmlFile(
            "config",
            null,
            plugin.getName() + ' configuration.'
        ));

        final healthIncraeseItemUtil = new HealthIncreaseItemUtil(plugin.getName(), plugin.getGame().getItemFactory(), config);

        plugin.getRegisterer().registerEvent(
            new PlayerDeathEvent(config)
        );
        plugin.getRegisterer().registerEvent(
            new PlayerRespawnEvent(config, plugin.getGame().getDisplayableMessageBuilder(), plugin.getScheduler())
        );
        plugin.getRegisterer().registerEvent(
            new PlayerInteractEvent(
                config,
                plugin.getGame().getDisplayableMessageBuilder(),
                healthIncraeseItemUtil,
                plugin.getGame()
            )
        );

        final healthIncreaseItemRecipe = config.getHealthIncreaseItemCraftingRecipe();
        final healthIncreaseItem = healthIncraeseItemUtil.createHealthIncreaseItem();
        if(healthIncreaseItem != null){
            plugin.getRegisterer().registerShapedRecipe(new ConstructableShapedRecipe(
                [
                    [healthIncreaseItemRecipe[0], healthIncreaseItemRecipe[1], healthIncreaseItemRecipe[2]],
                    [healthIncreaseItemRecipe[3], healthIncreaseItemRecipe[4], healthIncreaseItemRecipe[5]],
                    [healthIncreaseItemRecipe[6], healthIncreaseItemRecipe[7], healthIncreaseItemRecipe[8]]
                ],
                healthIncreaseItem
            ));
        }

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