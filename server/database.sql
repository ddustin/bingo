-- phpMyAdmin SQL Dump
-- version 2.11.9.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 17, 2012 at 05:36 PM
-- Server version: 5.0.67
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `bingo`
--

-- --------------------------------------------------------

--
-- Table structure for table `bingo_card`
--

CREATE TABLE IF NOT EXISTS `bingo_card` (
  `id` int(11) NOT NULL auto_increment,
  `show_id` int(11) NOT NULL,
  `json` varchar(2048) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `show_id` (`show_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `episode`
--

CREATE TABLE IF NOT EXISTS `episode` (
  `id` int(11) NOT NULL auto_increment,
  `show_id` int(11) NOT NULL,
  `season_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `description` varchar(2048) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `show_id` (`show_id`,`season_id`,`number`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `episode_card`
--

CREATE TABLE IF NOT EXISTS `episode_card` (
  `episode_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  PRIMARY KEY  (`episode_id`,`card_id`),
  KEY `order` (`order`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `season`
--

CREATE TABLE IF NOT EXISTS `season` (
  `id` int(11) NOT NULL auto_increment,
  `show_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `show_id` (`show_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `show`
--

CREATE TABLE IF NOT EXISTS `show` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(256) NOT NULL,
  `fb_id` varchar(128) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` char(40) NOT NULL,
  `salt` char(40) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `fb_id` (`fb_id`,`email`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_card`
--

CREATE TABLE IF NOT EXISTS `user_card` (
  `user_id` int(11) NOT NULL,
  `episode_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `receipt` varchar(256) NOT NULL,
  PRIMARY KEY  (`user_id`,`episode_id`,`card_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_device`
--

CREATE TABLE IF NOT EXISTS `user_device` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `salt` varchar(128) NOT NULL,
  `device_name` varchar(256) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
