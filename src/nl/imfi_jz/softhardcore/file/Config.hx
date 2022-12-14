package nl.imfi_jz.softhardcore.file;

import nl.imfi_jz.minecraft_api.KeyValueFile;

class Config {
    private final iniFile:KeyValueFile<String>;
    private static inline final HEALTH_REDUCTION_ON_DEATH_KEY = "Hearts lost upon death";

    public function new(iniFile) {
        this.iniFile = iniFile;

        if(iniFile.getValue(HEALTH_REDUCTION_ON_DEATH_KEY) == null){
            setHealthReductionOnDeath(1);
        }
    }

    public function getHealthReductionOnDeath():Float {
        return Std.parseFloat(iniFile.getValue(HEALTH_REDUCTION_ON_DEATH_KEY));
    }

    public function setHealthReductionOnDeath(value:Float) {
        iniFile.setValue(HEALTH_REDUCTION_ON_DEATH_KEY, Std.string(value));
    }
}