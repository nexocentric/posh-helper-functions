function Write-ColorizedMessage
{
	[CmdletBinding()]
	param (
		[ValidateNotNullOrEmpty()]
		[parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
		[string[]]$Message="This is a [{0}] message.",
		
		[ValidateNotNullOrEmpty()]
		[ValidateSet("Debug","Error","Verbose","Warning")]
		[string]$WriteAs="Verbose",

		[ValidateNotNullOrEmpty()]
		[ValidateSet("Black","Blue","Cyan","DarkBlue","DarkCyan","DarkGray","DarkGreen","DarkMagenta","DarkRed","DarkYellow","Gray","Green","Magenta","Red","White","Yellow")]
		[string]$BackgroundColor=$null,

		[ValidateNotNullOrEmpty()]
		[ValidateSet("Black","Blue","Cyan","DarkBlue","DarkCyan","DarkGray","DarkGreen","DarkMagenta","DarkRed","DarkYellow","Gray","Green","Magenta","Red","White","Yellow")]
		[string]$ForegroundColor=$null
	)
	begin
	{
		# $defaultMessage = $Message -f $WriteAs

		$hostVariables = (Get-Host).PrivateData
		$originalBackgroundColor = $hostVariables."${WriteAs}BackgroundColor"
		$originalForegroundColor = $hostVariables."${WriteAs}ForegroundColor"

		$selectedBackgroundcolor = if ($BackgroundColor) { $BackgroundColor } else { $originalBackgroundColor }
		$selectedForegroundColor = if ($ForegroundColor) { $ForegroundColor } else { $originalForegroundColor }

		$hostVariables."${WriteAs}BackgroundColor" = $selectedBackgroundcolor
		$hostVariables."${WriteAs}ForegroundColor" = $selectedForegroundColor

		$writeErrorRelatedParameters = $PSBoundParameters
		$PSBoundParameters
	}
	process
	{
		$Message | ForEach-Object -Process {
			switch ($WriteAs)
			{
				Debug { Write-Debug -Message $_ }
				Error { Write-Error -Message $_ }
				Verbose { Write-Verbose -Message $_ }
				Warning { Write-Warning -Message $_ }
			}
		}
	}
	end
	{
		$hostVariables."${WriteAs}BackgroundColor" = $originalBackgroundColor
		$hostVariables."${WriteAs}ForegroundColor" = $originalForegroundColor
	}
}