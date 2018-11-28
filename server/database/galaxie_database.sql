-- MySQL Script generated by MySQL Workbench
-- Wed Nov 28 13:54:48 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema galaxie
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `galaxie` ;

-- -----------------------------------------------------
-- Schema galaxie
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `galaxie` ;
USE `galaxie` ;

-- -----------------------------------------------------
-- Table `galaxie`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`user` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `steam_id` VARCHAR(45) NOT NULL,
  `nickname` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `steam_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`games`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`games` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`games` (
  `game_id` INT NOT NULL AUTO_INCREMENT,
  `game_name` VARCHAR(45) NULL,
  `game_script` VARCHAR(45) NULL,
  PRIMARY KEY (`game_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`servers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`servers` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`servers` (
  `server_id` INT(5) NOT NULL AUTO_INCREMENT,
  `creation_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  `game_id` INT NULL,
  PRIMARY KEY (`server_id`),
  INDEX `fk_servers_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_servers_games1_idx` (`game_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `galaxie`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servers_games1`
    FOREIGN KEY (`game_id`)
    REFERENCES `galaxie`.`games` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`players`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`players` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`players` (
  `player_id` INT NOT NULL AUTO_INCREMENT,
  `steam_id` VARCHAR(45) NOT NULL,
  `minecraft_id` VARCHAR(45) NULL,
  `discord_id` VARCHAR(45) NULL,
  `preferred_game` INT NULL,
  PRIMARY KEY (`player_id`),
  INDEX `preferred_game_idx` (`preferred_game` ASC) VISIBLE,
  INDEX `fk_players_user1_idx` (`steam_id` ASC) VISIBLE,
  CONSTRAINT `preferred_game`
    FOREIGN KEY (`preferred_game`)
    REFERENCES `galaxie`.`games` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_players_user1`
    FOREIGN KEY (`steam_id`)
    REFERENCES `galaxie`.`user` (`steam_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`products` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`products` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT 'Unknown',
  `cost` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`product_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`subscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`subscriptions` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`subscriptions` (
  `sub_id` INT NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  `sub_type` INT NOT NULL,
  `sub_started` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `sub_end` TIMESTAMP NULL,
  PRIMARY KEY (`sub_id`),
  INDEX `fk_subscriptions_players1_idx` (`player_id` ASC) VISIBLE,
  INDEX `fk_subscriptions_products1_idx` (`sub_type` ASC) VISIBLE,
  CONSTRAINT `fk_subscriptions_players1`
    FOREIGN KEY (`player_id`)
    REFERENCES `galaxie`.`players` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subscriptions_products1`
    FOREIGN KEY (`sub_type`)
    REFERENCES `galaxie`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`whitelist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`whitelist` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`whitelist` (
  `whitelist_id` INT NOT NULL AUTO_INCREMENT,
  `server_id` INT(5) NOT NULL,
  `enabled` TINYINT NOT NULL DEFAULT 0,
  `blacklist` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`whitelist_id`),
  INDEX `fk_whitelist_servers1_idx` (`server_id` ASC) VISIBLE,
  CONSTRAINT `fk_whitelist_servers1`
    FOREIGN KEY (`server_id`)
    REFERENCES `galaxie`.`servers` (`server_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`player_in_whitelist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`player_in_whitelist` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`player_in_whitelist` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  `whitelist_id` INT NOT NULL,
  `player_banned` TINYINT NOT NULL DEFAULT 0,
  `added_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `banned_date` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_player_in_whitelist_players1_idx` (`player_id` ASC) VISIBLE,
  INDEX `fk_player_in_whitelist_whitelist1_idx` (`whitelist_id` ASC) VISIBLE,
  CONSTRAINT `fk_player_in_whitelist_players1`
    FOREIGN KEY (`player_id`)
    REFERENCES `galaxie`.`players` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_in_whitelist_whitelist1`
    FOREIGN KEY (`whitelist_id`)
    REFERENCES `galaxie`.`whitelist` (`whitelist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`reported_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`reported_users` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`reported_users` (
  `report_id` INT NOT NULL,
  `player_id` INT NOT NULL,
  `reports` INT NOT NULL DEFAULT 0,
  `bans` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`report_id`),
  INDEX `fk_reported_users_players1_idx` (`player_id` ASC) VISIBLE,
  CONSTRAINT `fk_reported_users_players1`
    FOREIGN KEY (`player_id`)
    REFERENCES `galaxie`.`players` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `galaxie`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `galaxie`.`orders` ;

CREATE TABLE IF NOT EXISTS `galaxie`.`orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_orders_players1_idx` (`player_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_players1`
    FOREIGN KEY (`player_id`)
    REFERENCES `galaxie`.`players` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
