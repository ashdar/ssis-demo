CREATE TABLE [dbo].[MeterReadings] (
    [MeterID]          INT              NOT NULL,
    [ReadingID]        UNIQUEIDENTIFIER NOT NULL,
    [ReadingDate]      DATETIME2 (7)    NOT NULL,
    [ReadingWattHours] BIGINT           NOT NULL,
    [ReadingColor]     VARCHAR(32)    NOT NULL CONSTRAINT CK_MeterReadings_ReadingColor CHECK (ReadingColor in ('Red','Orange','Yellow','Green','Blue','Indigo','Violet')),
    [MedicionColor]    VARCHAR(32)    NOT NULL,
    [LoadDate] DATETIME2 NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_MeterReadings] PRIMARY KEY NONCLUSTERED ([MeterID] ASC, [ReadingID] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_MeterReadings_01]
    ON [dbo].[MeterReadings]([ReadingDate] ASC);

