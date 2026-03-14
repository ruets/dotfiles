package config

import (
	"fmt"
	"github.com/spf13/viper"
)

type Config struct {
	PreferredApps []string `mapstructure:"preferred_apps"`
}

var Cfg Config

func LoadConfig() error {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("$HOME/.config/dotman/")
	viper.AddConfigPath(".")

	if err := viper.ReadInConfig(); err != nil {
		return fmt.Errorf("config read error: %w", err)
	}

	if err := viper.Unmarshal(&Cfg); err != nil {
		return fmt.Errorf("config unmarshal error: %w", err)
	}
	return nil
}
