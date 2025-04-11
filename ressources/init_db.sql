-- Table : Player
CREATE TABLE `Player` (
    `uid` VARCHAR(255) PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `firstname` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `avatarUrl` TEXT
);

-- Table : Field
CREATE TABLE `Field` (
    `id` VARCHAR(255) PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `playerId` VARCHAR(255) NOT NULL,
    `specialty` VARCHAR(50) NOT NULL,
    FOREIGN KEY (`playerId`) REFERENCES `Player`(`uid`) ON DELETE CASCADE
);

-- Table : Slot
CREATE TABLE `Slot` (
    `id` VARCHAR(255) PRIMARY KEY,
    `fieldId` VARCHAR(255) NOT NULL,
    `kafeType` VARCHAR(50),
    `plantedAt` DATETIME,
    FOREIGN KEY (`fieldId`) REFERENCES `Field`(`id`) ON DELETE CASCADE
);

-- Table : Stock
CREATE TABLE `Stock` (
    `playerId` VARCHAR(255) PRIMARY KEY,
    `deevee` INT NOT NULL,
    `goldGrains` INT NOT NULL,
    FOREIGN KEY (`playerId`) REFERENCES `Player`(`uid`) ON DELETE CASCADE
);

-- Table : StockItem
CREATE TABLE `StockItem` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `stockPlayerId` VARCHAR(255) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `quantity` DOUBLE NOT NULL,
    `category` ENUM('fruit', 'grain') NOT NULL,
    FOREIGN KEY (`stockPlayerId`) REFERENCES `Stock`(`playerId`) ON DELETE CASCADE
);

-- Table : Blend
CREATE TABLE `Blend` (
    `id` VARCHAR(255) PRIMARY KEY,
    `ownerId` VARCHAR(255) NOT NULL,
    `totalWeight` DOUBLE NOT NULL,
    `createdAt` DATETIME NOT NULL,
    `gout` DOUBLE NOT NULL,
    `amertume` DOUBLE NOT NULL,
    `teneur` DOUBLE NOT NULL,
    `odorat` DOUBLE NOT NULL,
    FOREIGN KEY (`ownerId`) REFERENCES `Player`(`uid`) ON DELETE CASCADE
);

-- Table : Contest
CREATE TABLE `Contest` (
    `id` VARCHAR(255) PRIMARY KEY,
    `date` DATETIME NOT NULL,
    `completed` BOOLEAN NOT NULL,
    `winnerId` VARCHAR(255),
    `winnerName` VARCHAR(255),
    `modalShownToWinner` BOOLEAN NOT NULL,
    FOREIGN KEY (`winnerId`) REFERENCES `Player`(`uid`) ON DELETE SET NULL
);

-- Table : ContestSubmission
CREATE TABLE `ContestSubmission` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `contestId` VARCHAR(255) NOT NULL,
    `playerId` VARCHAR(255) NOT NULL,
    `submittedAt` DATETIME NOT NULL,
    `gout` DOUBLE NOT NULL,
    `amertume` DOUBLE NOT NULL,
    `teneur` DOUBLE NOT NULL,
    `odorat` DOUBLE NOT NULL,
    FOREIGN KEY (`contestId`) REFERENCES `Contest`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`playerId`) REFERENCES `Player`(`uid`) ON DELETE CASCADE
);
